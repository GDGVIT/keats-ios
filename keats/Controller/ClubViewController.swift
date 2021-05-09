//
//  ClubViewController.swift
//  keats
//
//  Created by Swamita on 04/05/21.
//

import UIKit
import SwiftyJSON

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
        uploadMenu.isHidden = true
        getClubDetails()

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
    
    func getClubDetails() {
        let url = URL(string: "https://keats-testing.herokuapp.com/api/clubs?club_id=adfcab83-dca1-49d5-b9dc-13dfdb2cba38")
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "JWToken") else {
            return}
        
        //print("JWTOKEN: \(token)")
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data {
                let json = JSON(data)
                debugPrint(json)
                
                if json["status"] == "success" {
                    //
                }
                
                
                
//
//                if json["status"] == "success" {
//                    let username = json["data"]["user"]["username"]
//                    UserDefaults.standard.set(username.rawString(), forKey: "username")
//
//                    let email = json["data"]["user"]["email"]
//                    UserDefaults.standard.set(email.rawString(), forKey: "email")
//
//                    let profile_pic = json["data"]["user"]["profile_pic"]
//                    if let profile_string = profile_pic.rawString() {
//                        guard let url = URL(string: profile_string) else {return}
//
//                        DispatchQueue.global().async {
//                            guard let data = try? Data(contentsOf: url) else {return }
//                            guard let image = UIImage(data: data) else {return }
//                            DispatchQueue.main.async {
//                                self.profileImage.image = image
//                            }
//                        }
//                    }
//                    UserDefaults.standard.set(profile_pic.rawString(), forKey: "profile_pic")
//
//                    let bio = json["data"]["user"]["bio"]
//                    UserDefaults.standard.set(bio.rawString(), forKey: "bio")
//
//                    let phone_number = json["data"]["user"]["phone_number"]
//                    UserDefaults.standard.set(phone_number.rawString(), forKey: "phone_number")
//
//                    let id = json["data"]["user"]["id"]
//                    UserDefaults.standard.set(id.rawString(), forKey: "id")
//
//                    let clubs = json["data"]["clubs"]
//
//                    for i in 0...clubs.count-1 {
//                        if let club_pic = json["data"]["clubs"][i]["club_pic"].rawString(),
//                        let clubname = json["data"]["clubs"][i]["clubname"].rawString(),
//                        let file_url = json["data"]["clubs"][i]["file_url"].rawString(),
//                        let host_id = json["data"]["clubs"][i]["host_id"].rawString(),
//                        let host_name = json["data"]["clubs"][i]["host_name"].rawString(),
//                        let host_profile_pic = json["data"]["clubs"][i]["host_profile_pic"].rawString(),
//                        let id = json["data"]["clubs"][i]["id"].rawString(),
//                        let page_no = json["data"]["clubs"][i]["page_no"].int,
//                        let page_sync = json["data"]["clubs"][i]["page_sync"].bool,
//                        let privatet = json["data"]["clubs"][i]["private"].int {
//
//                            let club = ClubModel(id: id, clubname: clubname, club_pic: club_pic, file_url: file_url, page_no: page_no, privatet: privatet, page_sync: page_sync, host_id: host_id, host_name: host_name, host_profile_pic: host_profile_pic)
//
//                            self.clubList.append(club)
//                        }
//
//                        //print(self.clubList.count)
//                    }
//
//                    DispatchQueue.main.async {
//                        self.activityIndicator.stopAnimating()
//                        self.activityIndicator.isHidden = true
//
//                        if clubs.count > 0 {
//                            self.readingImage.isHidden = true
//                            self.readingLabel.isHidden = true
//                            self.buttonStack.isHidden = true
//                            self.clubsTableView.isHidden = false
//                            self.buttonView.isHidden = false
//                            self.clubsTableView.reloadData()
//                        }
//                    }
//
//                }
            }
        }
        task.resume()
    }
}
