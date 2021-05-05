//
//  CreateClubViewController.swift
//  keats
//
//  Created by Swamita on 04/05/21.
//

import UIKit

class CreateClubViewController: UIViewController {

    @IBOutlet weak var clubImageView: UIView!
    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var privateToggle: UISwitch!
    @IBOutlet weak var syncToggle: UISwitch!
    @IBOutlet weak var selectedBookLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func imageUploadTapped(_ sender: Any) {
    }
    
    @IBAction func addBookPressed(_ sender: Any) {
    }
    
    @IBAction func removeSelectedtapped(_ sender: Any) {
    }
    
    @IBAction func submitTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
