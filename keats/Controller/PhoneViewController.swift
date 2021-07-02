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
    
    override func viewWillAppear(_ animated: Bool) {
        phoneTextField.text = ""
    }
    
    @IBAction func getOTPTapped(_ sender: Any) {
        
        guard let phone = phoneTextField.text else { return }
        let phoneLength = phone.count
        
        if phoneLength == 10 {
            
            if let countryCode = countryCodeTextField.text {
                let phoneNumber = countryCode+phone
                    buttonView.isHidden = true
                    activityIndicator.isHidden = false
                    activityIndicator.startAnimating()
                    
                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [self] (verificationID, error) in
                      if let error = error {
                        //print("Phone number error: \(error.localizedDescription)")
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        buttonView.isHidden = false
                        alert(message: "Check your internet connection and please try again", title: "Error")
                        print(error)
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
        } else {
            alert(message: "Enter a 10 digit phone number.", title: "Incorrect Phone Number")
        }
        
        
    }
}



