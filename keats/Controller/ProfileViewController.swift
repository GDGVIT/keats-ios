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
        fetchUserDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if isEditingProfile {
            makeNonEditable()
            
        } else {
            makeEditable()
        }
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
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
    
    private func loadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
            //utilityQueue.async {
                guard let data = try? Data(contentsOf: url) else { return }
                let image = UIImage(data: data)

                DispatchQueue.main.async {
                    completion(image)
                }
            
        }
    
    func fetchUserDetails() {
        let url = URL(string: "https://keats-testing.herokuapp.com/api/user")
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "JWToken") else {return}
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                let status = responseJSON["status"]
                if status as! String != "error" {
                    let userdata = responseJSON["data"]
                    if let userresponseJSON = userdata as? [String: Any] {
                        if let bio = userresponseJSON["bio"] as? String, let email = userresponseJSON["email"] as? String, let id = userresponseJSON["id"] as? String, let phone = userresponseJSON["phone_number"] as? String, let profile_pic = userresponseJSON["profile_pic"] as? String, let username = userresponseJSON["username"] as? String{
                            
                            print(id)
                            
                            guard let url = URL(string: profile_pic) else {
                                print("error1")
                                return}
                            print(url)
                            DispatchQueue.global().async {
                                guard let data = try? Data(contentsOf: url) else {
                                    print("error2")
                                    return }
                                guard let image = UIImage(data: data) else {
                                    print("error3")
                                    return }
                                DispatchQueue.main.async {
                                    self.profileImage.image = image
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.bioTextField.text = bio
                                self.emailTextField.text = email
                                self.nameTextField.text = username
                                self.phoneTextField.text = phone
                                
                            }
                            
                            
                        }
                        
                        
                                                
                        
                    }
                }
                
            }
        }
        task.resume()
    }
}
