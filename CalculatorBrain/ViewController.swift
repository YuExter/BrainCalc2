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
    
    var userInTheMiddleOfTyping: Bool = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTyping {
            if self.display.text! == "0" {
                self.display.text = digit
                self.userInTheMiddleOfTyping = true
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
        self.display.text = "0"
        self.userInTheMiddleOfTyping = false
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
            brain.performOperation(mathSymbol)
        }
        
        if let result = brain.result {
            self.displayValue = result
        }
    }


}

