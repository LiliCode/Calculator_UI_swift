//
//  Calculator.swift
//  Calculator
//
//  Created by 唯赢 on 2018/5/16.
//  Copyright © 2018年 李立. All rights reserved.
//

import Foundation




// 基本运算符
let opList = ["+", "-", "*", "/"]


enum ComputeError : Error {
    case empty
    case invalidOperator
    case syntaxAnalysisError
}


enum OperatorType {
    case undefine, Add, Sub, Mul, Div

    static func toOperatorType(symbol: String) -> OperatorType {
        switch symbol {
        case "+":
            return OperatorType.Add
        case "-":
            return OperatorType.Sub
        case "*":
            return OperatorType.Mul
        case "/":
            return OperatorType.Div
        default:
            return OperatorType.undefine
        }
    }
}


struct Node {
    var value: Double = Double()       // 节点值
    var op : OperatorType = OperatorType.undefine   // 节点运算
    var nodeList : [Node] = []  // 节点列表
    
    private func isExpression(_ exp: String) throws -> Bool {
        guard !exp.isEmpty else {
            throw ComputeError.syntaxAnalysisError
        }
        
        // 检测是否存在运算符: 如果存在运算符那就是一个表达式
        return exp.contains { (char: Character) -> Bool in
            return opList.contains(String(char))
        }
    }
    
    mutating func compute(_ exp: String) -> Double {
        do {
            if !(try isExpression(exp)) {
                if let value = Double(exp) {
                    self.value = value
                    return self.value
                }
            }
        } catch ComputeError.syntaxAnalysisError {
            print("语法错误")
            return Double()
        } catch {}
        
        // 拆分-计算
        var opSymbol : String = ""
        for op in opList {
            if exp.contains(op) {
                opSymbol = op
                break
            }
        }
        
        let expList: [String] = exp.components(separatedBy: opSymbol)
        var index: Int = 0
        for tExp in expList {
            var childNode = Node()
            self.op = OperatorType.toOperatorType(symbol: opSymbol)
            self.nodeList.insert(childNode, at: self.nodeList.endIndex)
            // 计算节点值
            if index == 0 {
                self.value = childNode.compute(tExp)
            } else {
                switch self.op {
                case .Add:
                    self.value += childNode.compute(tExp)
                case .Sub:
                    self.value -= childNode.compute(tExp)
                case .Mul:
                    self.value *= childNode.compute(tExp)
                case .Div:
                    self.value /= childNode.compute(tExp)
                default:
                    print("undefine")
                }
            }
            
            index += 1
        }
        
        return self.value
    }
}


class Calculator : NSObject {
    
    private static func syntaxAnalysis(_ exp: String) -> (description: String, code: ComputeError)? {
        guard !exp.isEmpty else {
            return ("表达式为空", ComputeError.empty)
        }
        
        return nil
    }
    
    private static func filter(_ exp: String, condition: (() -> String)?) -> String {
        var filterString = String()
        if let callback = condition {
            filterString = callback()
        } else {
            return exp
        }
        
        return exp.replacingOccurrences(of: filterString, with: "")
    }
    
    static func evaluate(_ expression: String) -> Double {
        // 语法分析
        if let error = syntaxAnalysis(expression) {
            print("ERROR: description:\(error.description) code:\(error.code)")
            return Double()
        }
        
        // 过滤无用字符
        let afterExp = filter(expression) { () -> String in
            return " "
        }
        
        // 节点解析，计算
        var mainNode = Node()
        return mainNode.compute(afterExp)
    }
}



