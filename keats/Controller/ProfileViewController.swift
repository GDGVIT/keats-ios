//
//  ProfileViewController.swift
//  keats
//
//  Created by Swamita on 06/04/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editToggleButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var isEditingProfile = false

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNonEditable()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if isEditingProfile {
            makeNonEditable()
            
        } else {
            makeEditable()
        }
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
    }
    
    func makeEditable() {
        isEditingProfile = true
        editToggleButton.setImage(UIImage(systemName: "checkmark"), for: .normal)

        nameTextField.isUserInteractionEnabled = true
        nameTextField.borderStyle = .roundedRect
        nameTextField.backgroundColor = UIColor(named: "TextFieldBg")
        
        bioTextField.isUserInteractionEnabled = true
        bioTextField.borderStyle = .roundedRect
        bioTextField.backgroundColor = UIColor(named: "TextFieldBg")
        
        emailTextField.isUserInteractionEnabled = true
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = UIColor(named: "TextFieldBg")
        
        phoneTextField.isUserInteractionEnabled = true
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.backgroundColor = UIColor(named: "TextFieldBg")
    }
    
    func makeNonEditable() {
        isEditingProfile = false
        editToggleButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        nameTextField.isUserInteractionEnabled = false
        nameTextField.borderStyle = .none
        nameTextField.backgroundColor = .clear
        
        bioTextField.isUserInteractionEnabled = false
        bioTextField.borderStyle = .none
        bioTextField.backgroundColor = .clear
        
        emailTextField.isUserInteractionEnabled = false
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .clear
        
        phoneTextField.isUserInteractionEnabled = false
        phoneTextField.borderStyle = .none
        phoneTextField.backgroundColor = .clear
    }
}
