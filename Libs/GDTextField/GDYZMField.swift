//
//  GDYZMField.swift
//  Reader
//
//  Created by CQSC  on 2017/7/31.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GDYZMField: UITextField ,UITextFieldDelegate{
    
    var previousTextFieldContent:String?
    
    var previousSelection:UITextRange?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.addTarget(self, action: #selector(GDYZMField.reformatAsCardNumber(textField:)), for: UIControl.Event.editingChanged)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func reformatAsCardNumber(textField:UITextField) {
        if let _ = textField.text {
            if textField.text!.length > 4 {
                textField.text = previousTextFieldContent
                textField.selectedTextRange = previousSelection
                return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text
        previousSelection = textField.selectedTextRange
        return true
    }
    
}
