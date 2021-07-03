//
//  CreateClubViewController.swift
//  keats
//
//  Created by Swamita on 04/05/21.
//

import UIKit
import FirebaseStorage

class CreateClubViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var clubImageView: UIView!
    @IBOutlet weak var clubImageImageView: UIImageView!
    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var privateToggle: UISwitch!
    
    private let storage = Storage.storage().reference()
    
    
    override func viewWillAppear(_ animated: Bool) {
        profileImageView.image = myProfileImage
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarColor(view: view)
        profileImageView.image = myProfileImage

       
    }
    

    @IBAction func imageUploadTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        clubImageImageView.image = image
        guard let imageData = image.pngData() else {
            return
        }
        
        let identifier = UUID()
        let path = "public/\(identifier).png"
        print(path)
        
        let uploadTask = storage.child(path).putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Uh-oh, an error occurred!")
                return
            }
            // Metadata contains file metadata such as size, content-type.
            //let size = metadata.size
            // You can also access to download URL after upload.
            self.storage.child(path).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Uh-oh, an error occurred! 2")
                    return
                }
                print(downloadURL.absoluteString)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBookPressed(_ sender: Any) {
    }
    
    @IBAction func submitTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func createNewClub() {
//        if let clubname = clubNameTextField.text {
//            
//        }
    }
}
