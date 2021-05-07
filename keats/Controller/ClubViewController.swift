//
//  ClubViewController.swift
//  keats
//
//  Created by Swamita on 04/05/21.
//

import UIKit

class ClubViewController: UIViewController {
    
    @IBOutlet weak var clubImageView: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var leaveClubLabel: UILabel!
    @IBOutlet weak var uploadMenu: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var membersTableView: UITableView!
    
    var currentAnimation = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func qrTapped(_ sender: Any) {
    }
    
    @IBAction func shareTapped(_ sender: Any) {
    }
    
    @IBAction func chatTapped(_ sender: Any) {
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations:  {
            switch self.currentAnimation {
            case 0:
                self.buttonView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
                self.uploadMenu.isHidden = false
                self.uploadMenu.alpha = 1
            case 1:
                self.buttonView.transform = .identity
                self.uploadMenu.alpha = 0
                self.uploadMenu.isHidden = true
                
            
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        if currentAnimation > 1 {
            currentAnimation = 0
        }
    }
    
    @IBAction func uploadPDFTapped(_ sender: Any) {
    }
    
    @IBAction func uploadEPUBTapped(_ sender: Any) {
    }
    
    @IBAction func leaveTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
