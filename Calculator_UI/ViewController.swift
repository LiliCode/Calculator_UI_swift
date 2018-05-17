//
//  ViewController.swift
//  Calculator_UI
//
//  Created by 唯赢 on 2018/5/17.
//  Copyright © 2018年 李立. All rights reserved.
//

import UIKit
//import Calculator

let operatorSymbolList: [String] = ["/", "*", "-", "+"]

class ViewController: UIViewController {
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    var isCompute: Bool = false
    var lastOperator: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 圆角
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for button in self.buttons {
                button.layer.masksToBounds = true
                button.layer.cornerRadius = (button.frame.size.height-3) / 2.0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func clickAction(_ sender: UIButton) {
        switch sender.tag {
        case 0 ... 10:
            self.numberKeyboard(sender.tag)
            print("数字键：\(sender.tag)")
        case 100 ... 102:
            self.commandKeyboard(sender.tag)
            print("命令键：\(sender.tag)")
        case 200 ... 204:
            self.operatorKeyboard(sender.tag)
            print("操作键：\(sender.tag)")
        
        default:
            print("不支持的键值")
        }
    }
    
    func numberKeyboard(_ number: Int) {
        // 判断显示的是否是初始状态
        if self.isCompute {
            self.resultLabel.text? = "0"
            self.expressionLabel.text? = ""
            self.isCompute = false
        }
        
        if number == 10 {
            self.expressionLabel.text? += "."
        } else {
            self.expressionLabel.text? += "\(number)"
        }
    }
    
    func commandKeyboard(_ command: Int) {
        switch command {
        case 100:
            self.resultLabel.text? = "0"
            self.expressionLabel.text? = "0"
        default:
            print("呵呵")
        }
    }
    
    func operatorKeyboard(_ oper: Int) {
        if oper == 204 {
            // 计算
            self.isCompute = true
            let result = Calculator.evaluate(self.expressionLabel.text!)
            self.resultLabel.text = "\(result)"
            return
        }
        
        let symbol = operatorSymbolList[oper - 200]
        guard self.lastOperator != symbol else {
            return
        }
        
        self.expressionLabel.text? += symbol
        self.lastOperator = symbol
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        print("界面释放")
    }
}

