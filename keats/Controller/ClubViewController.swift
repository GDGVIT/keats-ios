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
    var users : [UserModel] = []
    var clubId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membersTableView.delegate = self
        membersTableView.dataSource = self
        uploadMenu.isHidden = true
        getClubDetails(clubid: clubId)
    }
    
    @IBAction func qrTapped(_ sender: Any) {
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        let text = clubId
        var textToShare = [ text ] as [Any]
        
        if let qrImage = generateQRCode(from: text) {
            textToShare = [ text, qrImage ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        
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
        leaveClub(id: clubId)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Get club details
    
    func getClubDetails(clubid: String) {
        let urlString = "https://keats-testing.herokuapp.com/api/clubs?club_id=\(clubid)"
        let url = URL(string: urlString)
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
                    let clubname = json["data"]["club"]["clubname"].string
                    let club_pic = json["data"]["club"]["club_pic"].rawString()
                    let host_name = json["data"]["club"]["host_name"].string
                    let file_url = json["data"]["club"]["file_url"].rawString()
                    let privacy = json["data"]["club"]["private"].bool == true ? "Private" : "Public"
                    
                    if let profile_string = club_pic {
                        guard let url = URL(string: profile_string) else {return}
                        
                        DispatchQueue.global().async {
                            guard let data = try? Data(contentsOf: url) else {return }
                            guard let image = UIImage(data: data) else {return }
                            DispatchQueue.main.async {
                                self.clubImageView.image = image
                            }
                        }
                    }
                    
                    let users = json["data"]["users"]
                    if users.count > 0 {
                        for i in 0...users.count-1 {
                            if let id = json["data"]["users"][i]["id"].string,
                               let username = json["data"]["users"][i]["username"].string,
                               let profile_pic = json["data"]["users"][i]["profile_pic"].string,
                               let bio = json["data"]["users"][i]["bio"].string,
                               let phone_number = json["data"]["users"][i]["phone_number"].string,
                               let email = json["data"]["users"][i]["email"].string {
                                
                                let user = UserModel(bio: bio, email: email, id: id, phone_number: phone_number, profile_pic: profile_pic, username: username)
                                
                                self.users.append(user)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.clubNameLabel.text = clubname
                        self.hostLabel.text = host_name
                        self.privacyLabel.text = privacy
                        self.membersTableView.reloadData()
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: - Leave Club
    
    func leaveClub(id: String) {
        let json: [String: Any] = ["club_id": id]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        guard let url = URL(string: "https://keats-testing.herokuapp.com/api/clubs/leave") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = UserDefaults.standard.string(forKey: "JWToken") else {
            return}
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                let status = responseJSON["status"] as? String
                if status  == "success" {
                    
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    
                } else {
                    if let message = responseJSON["message"] as? String, let status = responseJSON["status"] as? String {
                        self.alert(message: message, title: status)
                    }
                }
            }
        }
        
        task.resume()
    }
}


//MARK: - Table View Methods

extension ClubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.bio
        return cell
    }
    
    
}
