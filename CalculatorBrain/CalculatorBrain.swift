//
//  CalculatorBrain.swift
//  CalculatorBrain
//
//  Created by Юля Пономарева on 12.11.17.
//  Copyright © 2017 Юля Пономарева. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var accumulator: Double?
    
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
        "y^2" : Operation.unaryOperation({ $0 * $0 }),
        "y^3" : Operation.unaryOperation({ pow($0, 3) }),
        "y^n" : Operation.binaryOperation({ pow($0, $1) }),
        "C" : Operation.clear
        ]
    
    mutating func performOperation(_ symbol: String) {
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
                    self.accumulator = nil
                }
            case .equals:
                performBinaryOperation()
            case .clear:
                self.accumulator = nil
                self.pendingBinaryOperation = nil
            }
        }
    }
    
    private mutating func performBinaryOperation() {
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
    
    mutating func setOperand(operand: Double) {
        self.accumulator = operand
    }
    
    var result: Double? {
        get {
            return self.accumulator
        }
    }
}
