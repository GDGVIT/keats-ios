//
//  PhoneViewController.swift
//  keats
//
//  Created by Swamita on 01/04/21.
//

import UIKit
import Firebase

class PhoneViewController: UIViewController {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView.layer.cornerRadius = 4
        buttonView.layer.borderWidth = 3
        buttonView.layer.borderColor = UIColor(named: "KeatsViolet")?.cgColor
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getOTPTapped(_ sender: Any) {
        
            if let phoneNumber = phoneTextField.text {
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                  if let error = error {
                    print(error.localizedDescription)
                    return
                  }
                  // Sign in using the verificationID and the code sent to the user
                  // ...
                    UserDefaults.standard.set(verificationID, forKey: "VerificationID")
                    print("Verification id saved")                    
                    self.performSegue(withIdentifier: "phoneToOtp", sender: self)
                }
            }
        

            
        
        
        
        
    }
    
}
