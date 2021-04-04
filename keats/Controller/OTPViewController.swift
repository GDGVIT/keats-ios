//
//  OTPViewController.swift
//  keats
//
//  Created by Swamita on 04/04/21.
//

import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var otpContainerView: UIView!
    @IBOutlet weak var testButton: UIButton!
    
    let otpStackView = OTPStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        testButton.isHidden = true
        otpContainerView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
    }
    
    @IBAction func clickedForHighlight(_ sender: UIButton) {
           print("Final OTP : ",otpStackView.getOTP())
           otpStackView.setAllFieldColor(isWarningColor: true, color: .yellow)
       }

}

extension OTPViewController: OTPDelegate {
    
    func didChangeValidity(isValid: Bool) {
        testButton.isHidden = !isValid
    }
    
}
