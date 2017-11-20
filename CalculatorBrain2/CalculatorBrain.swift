//
//  CalculatorBrain.swift
//  CalculatorBrain
//
//  Created by Юля Пономарева on 12.11.17.
//  Copyright © 2017 Юля Пономарева. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumulator: Double?
    private var variablesArr = [String : Double]()
    private var expression = [String]()
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "pi" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "sqrt" : Operation.unaryOperation(sqrt), //sqrt,
        "cos": Operation.unaryOperation(cos), //cos
        "+-" : Operation.unaryOperation({ -$0 }),
        "x" : Operation.binaryOperation({ $0 * $1 }),
        "/" : Operation.binaryOperation({ (op1, op2) in
            if op2 == 0 {
                return 0
            }
            return op1
        }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "=" : Operation.equals,
        "C" : Operation.clear,
        "y^2" : Operation.unaryOperation({ $0 * $0 })
        ]
    
    func addOperation(_ symbol: String) {
        self.expression.append(symbol)
    }
    
    func performOperation(_ symbol: String) {
        if let operation = self.operations[symbol] {
            switch operation {
            case .constant(let value):
                self.accumulator = value
            case .unaryOperation(let function):
                if self.accumulator != nil {
                    self.accumulator = function(self.accumulator!)
                }
            case .binaryOperation(let function):
                if self.accumulator != nil {
                    self.pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: self.accumulator!)
                }
            case .equals:
                performBinaryOperation()
            case .clear:
                self.clear()
            }
        }
    }
    
    private func performBinaryOperation() {
        if self.pendingBinaryOperation != nil && self.accumulator != nil {
            self.accumulator = self.pendingBinaryOperation!.perform(with: self.accumulator!)
            self.pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    func setOperand(operand: Double) {
        self.expression.append(String(operand))
    }
    
    func setOperand(variable: String) {
        self.expression.append(variable)
    }
    
    func clear() {
        self.accumulator = 0
        self.pendingBinaryOperation = nil
        self.expression.removeAll()
        self.variablesArr.removeAll()
    }
    
    func undo() {
        if(self.expression.count >= 1) {
            self.expression.removeLast()
        }
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool) {
            if variables != nil {
                self.variablesArr = variables!
            }
            self.accumulator = 0
            self.pendingBinaryOperation = nil
            
            for entry in self.expression {
                print(entry)
                if let operand = Double(entry) {
                    accumulator = operand
                } else if let _ = operations[entry] {
                    performOperation(entry)
                } else {
                    accumulator = self.variablesArr[entry] ?? 0.0
                }
            }
            return (accumulator, self.pendingBinaryOperation != nil)
    }
    
    var result: Double? {
        get {
            return self.accumulator
        }
    }
}
