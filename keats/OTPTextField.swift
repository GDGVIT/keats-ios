//
//  OTPTextField.swift
//  keats
//
//  Created by Swamita on 04/04/21.
//

import Foundation
import UIKit.UITextField

class OTPTextField: UITextField {
  weak var previousTextField: OTPTextField?
  weak var nextTextField: OTPTextField?
  override public func deleteBackward(){
    text = ""
    previousTextField?.becomeFirstResponder()
   }
}
