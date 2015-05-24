//
//  MemeTextDelegate.swift
//  TestTextFieldEditor
//
//  Created by Brian Josel on 4/30/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

enum Position {
    //Enum for Position variable in MemeTextDelegate
    case Top, Bottom
    init () {   //set outside of enum to .Bottom if needed
        self = .Top
    }
    
}

extension Position: Printable {
    //Allows Position Enum to be Printable
    
    var description: String {
        get {
            switch (self) {
            case .Top:
                return "TOP"
            case .Bottom:
                return "BOTTOM"
            }
        }
    }
}

class MemeTextDelegate: NSObject, UITextFieldDelegate {
    
    //Delegate variables for top/bottom position, and if user entered text or not
    var position = Position()
    var userEnteredText = false //Default value
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //clear text if it was not entered by the user (e.g. clear the default text)
        if !userEnteredText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //if user entered text, leave it and make userEnteredText true, if not, make false and display default text
        if textField.text == "" {
            userEnteredText = false
        } else {
            userEnteredText = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard when user hits return
        textField.resignFirstResponder()
        return true
    }
}