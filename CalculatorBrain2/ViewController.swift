//
//  ViewController.swift
//  CalculatorBrain
//
//  Created by Юля Пономарева on 12.11.17.
//  Copyright © 2017 Юля Пономарева. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var MDisplay: UILabel!
    
    var userInTheMiddleOfTyping: Bool = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTyping {
            if self.display.text! == "0" {
                self.display.text = digit
            } else {
                let textCurrentlyDisplay = self.display.text!
                self.display.text = textCurrentlyDisplay + digit
            }
        } else {
            self.display.text = digit
            self.userInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func touchClearButton(_ sender: UIButton) {
        self.brain.performOperation(sender.currentTitle!)
        let (result, _) = brain.evaluate()
        self.userInTheMiddleOfTyping = false
        self.displayValue = result!
        self.MDisplay.text = "M = 0"
    }
    
    @IBAction func eraseDigit(_ sender: UIButton) {
        if(self.userInTheMiddleOfTyping) {
            var displayedText = display.text!
            switch displayedText.count {
            case let count where count > 1:
                displayedText.remove(at: displayedText.index(before: displayedText.endIndex))
                self.display.text = displayedText
            case let count where count == 1:
                self.display.text = "0"
            default:
                break
            }
        } else {
            brain.undo()
            self.updateUI()
        }
    }
    
    @IBAction func touchFloatDot() {
        if self.userInTheMiddleOfTyping {
            guard let textCurrentDisplay = self.display.text, !textCurrentDisplay.contains(".") else {
                return
            }
            let textCurrentlyDisplay = self.display.text!
            self.display.text = textCurrentlyDisplay + "."
        } else {
            guard let textCurrentDisplay = self.display.text, !textCurrentDisplay.contains(".") else {
                return
            }
            self.display.text = textCurrentDisplay + "."
            self.userInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func setVariable() {
        self.brain.setOperand(variable: "M")
        self.userInTheMiddleOfTyping = false
    }
    
    @IBAction func evaluateVariable(_ sender: UIButton) {
        let variableValues: [String: Double] = ["M": self.displayValue]
        self.MDisplay.text = "M = \(displayValue)"
        let (result, _) = brain.evaluate(using: variableValues)
        self.userInTheMiddleOfTyping = false
        self.displayValue = result!
    }
    
    var displayValue: Double {
        get {
            return Double(self.display.text!)!
        }
        set {
            self.display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if self.userInTheMiddleOfTyping {
            brain.setOperand(operand: self.displayValue)
            self.userInTheMiddleOfTyping = false
        }
        
        if let mathSymbol = sender.currentTitle {
            brain.addOperation(mathSymbol)
        }
        
        self.updateUI()
    }
    
    func updateUI() {
        let (result, _) = brain.evaluate()
        displayValue = result!
    }
}
