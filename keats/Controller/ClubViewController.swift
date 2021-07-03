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
    @IBOutlet weak var privateToggle: UISwitch!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var clubInfoView: UIView!
    @IBOutlet weak var membersLabel: UILabel!
    
    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leaveView: UIView!
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var currentAnimation = 0
    var users : [UserModel] = []
    var clubId : String = ""
    var isHost = false
    var inEditMode = false
    var hostId: String = ""
    var clubImageUrl: String = ""
    var clubFileUrl: String = ""
    var isPrivate: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        editButton.isHidden = true
        uploadImageView.isHidden = true
        buttonView.isHidden = true
        uploadMenu.isHidden = true
        clubInfoView.isHidden = true
        membersTableView.isHidden = true
        membersLabel.isHidden = true
        leaveView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        profileImageView.image = myProfileImage
        clubNameTextField.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getClubDetails(clubid: clubId)
        privateToggle.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarColor(view: view)
        
        chatButton.isHidden = true
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberIdentifier")
    }
    
    func showStuff() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        clubInfoView.isHidden = false
        membersTableView.isHidden = false
        membersLabel.isHidden = false
        leaveView.isHidden = false
    }
    
    @IBAction func qrTapped(_ sender: Any) {
        inEditMode.toggle()
        if inEditMode {
            enableEditMode()
            editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            saveAndDisableEditMode()
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        let text = clubId
        
        if let qrImage = generateQRCode(from: text) {
            
            let textToShare = [ qrImage ] as [Any]
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
    
    @IBAction func readTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "clubToRead", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ReadViewController {
            let vc = segue.destination as? ReadViewController
            vc?.clubId = clubId
        }
        
        if segue.destination is ChatViewController {
            let vc = segue.destination as? ChatViewController
            vc?.clubId = clubId
        }
    }
    
    @IBAction func uploadImageTapped(_ sender: Any) {
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
    
    func enableEditMode() {
        privateToggle.isHidden = false
        clubNameTextField.isHidden = false
        clubNameLabel.isHidden = true
        clubNameTextField.text = clubNameLabel.text
        privacyLabel.text = "Private"
        buttonView.isHidden = false
        uploadMenu.isHidden = true
        uploadImageView.isHidden = false
        membersTableView.reloadData()
        
    }
    
    func saveAndDisableEditMode() {
        privateToggle.isHidden = true
        clubNameTextField.isHidden = true
        clubNameLabel.isHidden = false
        clubNameLabel.text = clubNameTextField.text
        
        if privateToggle.isOn {
            privacyLabel.text = "Private"
            if !isPrivate {
                updatePrivacy()
                isPrivate = true
            }
        } else {
            privacyLabel.text = "Public"
            if isPrivate {
                updatePrivacy()
                isPrivate = false
            }
        }
        
        buttonView.isHidden = true
        uploadMenu.isHidden = true
        uploadImageView.isHidden = true
        membersTableView.reloadData()
        updateClub(imageUrl: "")
    }
    
    //MARK: - Update Privacy
    
    func updatePrivacy() {
        
        let json: [String: Any] = ["club_id": clubId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        guard let url = URL(string: "https://keats-testing.herokuapp.com/api/clubs/toggleprivate") else {return}
        
        prepareRequest(method: "POST", url: url, jsonData: jsonData)
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
                //debugPrint(json)
                
                if json["status"] == "success" {
                    let clubname = json["data"]["club"]["clubname"].string
                    let club_pic = json["data"]["club"]["club_pic"].rawString()
                    let host_name = json["data"]["club"]["host_name"].string
                    let file_url = json["data"]["club"]["file_url"].rawString()
                    let privacy = json["data"]["club"]["private"].bool == true ? "Private" : "Public"
                    self.isPrivate = json["data"]["club"]["private"].bool ?? false
                    
                    let host_id = json["data"]["club"]["host_id"].string
                    guard let uid = UserDefaults.standard.string(forKey: "uid") else {
                        return}
                    self.hostId = host_id ?? ""
                    self.clubFileUrl = file_url ?? ""
                    self.clubImageUrl = club_pic ?? ""
                    if uid == host_id {
                        self.isHost = true
                        print("User is host")
                        DispatchQueue.main.async {
                            self.editButton.isHidden = false
                            self.buttonView.isHidden = false
                        }
                        
                    }
                    
                    
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
                        self.showStuff()
                        self.view.isUserInteractionEnabled = true
                        self.view.alpha = 1
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: - Leave Club
    
    
    
    //MARK: - Remove User
    
    func removeUser(userId: String) {
        let json: [String: Any] = ["club_id": clubId, "user_id": userId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url = URL(string: "https://keats-testing.herokuapp.com/api/clubs/kickuser") else {return}
        
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
                            //self.navigationController?.popViewController(animated: true)
                            self.view.isUserInteractionEnabled = false
                            self.view.alpha = 0.5
                            self.getClubDetails(clubid: self.clubId)
                        }
                    
                } else {
                    if let message = responseJSON["message"] as? String {
                        DispatchQueue.main.async {
                            self.alert(message: message, title: "Error")
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
    //MARK: - update club

    func updateClub(imageUrl: String) {
        
        if let clubName = clubNameTextField.text {
            view.isUserInteractionEnabled = false
            view.alpha = 0.5
            
            //update image url
            
            let json: [String: Any] = ["id": clubId,
                                       "clubname": clubName,
                                       "club_pic": clubImageUrl,
                                       "file": clubFileUrl]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            guard let url = URL(string: "https://keats-testing.herokuapp.com/api/clubs/update") else {return}
            
            prepareRequest(method: "PATCH", url: url, jsonData: jsonData)
            view.isUserInteractionEnabled = true
            view.alpha = 1
        }
    }
}



//MARK: - Table View Methods

extension ClubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberIdentifier") as! MemberTableViewCell
        let user = users[indexPath.row]
        cell.usernameLabel.text = user.username
        cell.bioLabel.text = user.bio
        cell.removeButton.addTarget(self, action:#selector(ClubViewController.checkTapped(_:)),
                                    for: .touchUpInside)
        
        let uid = UserDefaults.standard.string(forKey: "uid")

        if isHost {
            if inEditMode {
                if uid == user.id {
                    cell.removeButton.isHidden = true
                    cell.hostMarkView.isHidden = false
                } else {
                    cell.removeButton.isHidden = true
                    cell.hostMarkView.isHidden = false
                }
            } else {
                cell.removeButton.isHidden = true
                cell.hostMarkView.isHidden = false
            }
        } else {
            if hostId == user.id {
                cell.removeButton.isHidden = true
                cell.hostMarkView.isHidden = false
            } else {
                cell.removeButton.isHidden = true
                cell.hostMarkView.isHidden = true
            }
        }
        
        if let imgurl = URL.init(string: user.profile_pic) {
            cell.profileImageView.loadImage(url: imgurl)
        }
        return cell
    }
    
    
    @objc func checkTapped(_ sender: UIButton) {
        //print(sender.tag)
        
        let toRemoveIndex = sender.tag
        //print(toRemoveIndex)
        let toRemoveUid = users[toRemoveIndex].id
        removeUser(userId: toRemoveUid)
    }
    
    
    
}


