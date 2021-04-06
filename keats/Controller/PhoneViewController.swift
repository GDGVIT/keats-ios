//
//  PhoneViewController.swift
//  keats
//
//  Created by Swamita on 01/04/21.
//

import UIKit
import Firebase
import MRCountryPicker

class PhoneViewController: UIViewController, MRCountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryCodeTextField.text = phoneCode
    }
    
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    
    let countryPicker =  MRCountryPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        buttonView.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        countryCodeTextField.inputView = countryPicker
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setLocale("sl_SI")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @IBAction func getOTPTapped(_ sender: Any) {
        
        if let countryCode = countryCodeTextField.text, let phone = phoneTextField.text {
            let phoneNumber = countryCode+phone
                buttonView.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [self] (verificationID, error) in
                  if let error = error {
                    print("Phone number error: \(error.localizedDescription)")
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    buttonView.isHidden = false
                    alert(message: error.localizedDescription, title: "Check Phone Number")
                    return
                  }
                  // Sign in using the verificationID and the code sent to the user
                  // ...
                    UserDefaults.standard.set(verificationID, forKey: "VerificationID")
                    print("Verification id saved")                    
                    self.performSegue(withIdentifier: "phoneToOtp", sender: self)
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    buttonView.isHidden = false
                }
            }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}



extension UIViewController {
    
    func alert(message: String, title: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
