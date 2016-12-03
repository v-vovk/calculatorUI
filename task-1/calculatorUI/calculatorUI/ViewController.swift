//
//  ViewController.swift
//  calculatorUI
//
//  Created by Vlad Vovk on 30.11.16.
//  Copyright © 2016 wolfykey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayResultLabel: UILabel!
    var nowTyping = false // змінна для перевірки чи введене якесь число
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSign: String = "" //змінна для знаку дії між операторами
    var dotIsPlaced = false //для перевірки точки
    
    var currentInput: Double { //сюди запишемо число з лейбла в змінну типу Double
        get {
            return Double(displayResultLabel.text!)!
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                displayResultLabel.text = "\(valueArray[0])"
            } else {
                displayResultLabel.text = "\(newValue)"
            }
            nowTyping = false
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!  // присвоюється цифра з тайтла
        
        /*
          Обрізаємо максимальну кількість знаків до 20.
          Якщо більше, їх то не виконуємо нічого.
          
          Якщо now Typing = false це означає, що нічого не ведено.
          Тому коли нажмемо кнопку, на лейбл виведеться нажата цифра.
          Тобто nowTyping стане true, і до числа що на лейблі дописуватиметься введене.
        */
        if nowTyping {
            if (displayResultLabel.text?.characters.count)! < 20 {
                displayResultLabel.text = displayResultLabel.text! + number
            }
        } else {
            displayResultLabel.text = number
            nowTyping = true
        }
    }

    @IBAction func twoOperandsSignPressed(_ sender: UIButton) {
        operationSign = sender.currentTitle! // присвоюємо знак дії з натиснутої кнопки
        firstOperand = currentInput
        nowTyping = false
        dotIsPlaced = false
        
    }
    
    func operateWithTwoOperand(operation: (Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        nowTyping = false
    }
    
    @IBAction func equalitySignPressed(_ sender: UIButton) {
        if nowTyping {
            secondOperand = currentInput
        }
        
        dotIsPlaced = false
        
        switch operationSign {
            case "+":
                operateWithTwoOperand{$0 + $1}
            case "-":
                operateWithTwoOperand{$0 - $1}
            case "÷":
                operateWithTwoOperand{$0 / $1}
            case "×":
                operateWithTwoOperand{$0 * $1}
        default: break
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        displayResultLabel.text = "0"
        nowTyping = false
        operationSign = ""
        dotIsPlaced = false
    }
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        if displayResultLabel.text != "0" {
            currentInput = -currentInput
        }
    }
    
    /*
     є проблеми, проценти рахує неправильно.
     даний приклад коду брав з інету, але він не працює як слід
     */
    @IBAction func percentageButtonPressed(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
    }
    
    @IBAction func squareRootButtonPressed(_ sender: UIButton) {
        currentInput = sqrt(currentInput)
    }
    
    
    /*
     є баг, не розумію як виправити.
     якшо одразу натискати на точку, то їх можна поставити кілька, 
     і далі вже код не працює.
     */
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if nowTyping && !dotIsPlaced {
            displayResultLabel.text = displayResultLabel.text! + "."
            dotIsPlaced = true
        } else if !nowTyping && !dotIsPlaced { //якщо одразу нажмемо точку то добавить перед нею 0
            displayResultLabel.text = "0."
            nowTyping = true
        }
    }
}

