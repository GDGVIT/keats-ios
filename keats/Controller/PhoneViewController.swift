//
//  PhoneViewController.swift
//  keats
//
//  Created by Swamita on 01/04/21.
//

import UIKit
import Firebase

class PhoneViewController: UIViewController {
    
    var phoneToggle = true

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView.layer.cornerRadius = 4
        buttonView.layer.borderWidth = 3
        buttonView.layer.borderColor = UIColor(named: "KeatsViolet")?.cgColor

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getOTPTapped(_ sender: Any) {
        if phoneToggle {
            if let phoneNumber = phoneTextField.text {
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                  if let error = error {
                    print(error.localizedDescription)
                    return
                  }
                  // Sign in using the verificationID and the code sent to the user
                  // ...
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    self.phoneToggle = false
                    print("Verification id saved")
                    
                    
                }
            }
        } else {
            if let verificationCode = phoneTextField.text {
                if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
                    
                    let credential = PhoneAuthProvider.provider().credential(
                        withVerificationID: verificationID,
                        verificationCode: verificationCode)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                      if let error = error {
                        let authError = error as NSError
                        print(authError.localizedDescription)
                      }
                      // User is signed in
                      // ...
                        print("signed in")
                    }
                }
            }
            
        }
        
        
        
    }
    
}
