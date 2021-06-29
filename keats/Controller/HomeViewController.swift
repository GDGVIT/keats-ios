//
//  HomeViewController.swift
//  keats
//
//  Created by Swamita on 04/04/21.
//

import UIKit
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet weak var readingImage: UIImageView!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var joinButtonView: UIView!
    @IBOutlet weak var popUpOptionView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var clubsTableView: UITableView!
    @IBOutlet weak var popupCreateButtonView: UIView!
    @IBOutlet weak var popupJoinButtonView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var clubList : [ClubModel] = []
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubsTableView.delegate = self
        clubsTableView.dataSource = self
        joinButtonView.curvedButtonView(color: "KeatsViolet")
        popupJoinButtonView.curvedButtonView(color: "KeatsOrange")
        popupCreateButtonView.curvedButtonView(color: "KeatsOrange")
        clubsTableView.isHidden = true
        buttonView.isHidden = true
        popUpOptionView.isHidden = true
        activityIndicator.isHidden = false
        readingImage.isHidden = true
        readingLabel.isHidden = true
        buttonStack.isHidden = true
        activityIndicator.startAnimating()
        fetchClubDetails()
        clubsTableView.register(UINib(nibName: "ClubTableViewCell", bundle: nil), forCellReuseIdentifier: "ClubCell")
    }
    
    @IBAction func createClubTapped(_ sender: Any) {
    }
    
    @IBAction func joinClubTapped(_ sender: Any) {
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations:  {
            switch self.currentAnimation {
            case 0:
                self.buttonView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
                self.popUpOptionView.isHidden = false
                self.popUpOptionView.alpha = 1
            case 1:
                self.buttonView.transform = .identity
                self.popUpOptionView.alpha = 0
                self.popUpOptionView.isHidden = true
                
            
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
    
//    private func loadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
//        utilityQueue.async {
//                guard let data = try? Data(contentsOf: url) else { return }
//                let image = UIImage(data: data)
//
//                DispatchQueue.main.async {
//                    completion(image)
//                }
//            }
//        }
    
}

//MARK: - fetch club details

extension HomeViewController {
    func fetchClubDetails() {
        //print("Fetching club details...")
        let url = URL(string: "https://keats-testing.herokuapp.com/api/user/clubs")
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
                    let username = json["data"]["user"]["username"]
                    UserDefaults.standard.set(username.rawString(), forKey: "username")
                    
                    let email = json["data"]["user"]["email"]
                    UserDefaults.standard.set(email.rawString(), forKey: "email")
                    
                    let profile_pic = json["data"]["user"]["profile_pic"]
                    if let profile_string = profile_pic.rawString() {
                        guard let url = URL(string: profile_string) else {return}
                        
                        DispatchQueue.global().async {
                            guard let data = try? Data(contentsOf: url) else {return }
                            guard let image = UIImage(data: data) else {return }
                            DispatchQueue.main.async {
                                self.profileImage.image = image
                            }
                        }
                    }
                    UserDefaults.standard.set(profile_pic.rawString(), forKey: "profile_pic")

                    let bio = json["data"]["user"]["bio"]
                    UserDefaults.standard.set(bio.rawString(), forKey: "bio")
                    
                    let phone_number = json["data"]["user"]["phone_number"]
                    UserDefaults.standard.set(phone_number.rawString(), forKey: "phone_number")
                    
                    let id = json["data"]["user"]["id"]
                    UserDefaults.standard.set(id.rawString(), forKey: "id")
                    
                    let clubs = json["data"]["clubs"]
                    
                    if clubs.count > 0 {
                        for i in 0...clubs.count-1 {
                            if let club_pic = json["data"]["clubs"][i]["club_pic"].rawString(),
                            let clubname = json["data"]["clubs"][i]["clubname"].rawString(),
                            let file_url = json["data"]["clubs"][i]["file_url"].rawString(),
                            let host_id = json["data"]["clubs"][i]["host_id"].rawString(),
                            let host_name = json["data"]["clubs"][i]["host_name"].rawString(),
                            let host_profile_pic = json["data"]["clubs"][i]["host_profile_pic"].rawString(),
                            let id = json["data"]["clubs"][i]["id"].rawString(),
                            let page_no = json["data"]["clubs"][i]["page_no"].int,
                            let page_sync = json["data"]["clubs"][i]["page_sync"].bool,
                            let privatet = json["data"]["clubs"][i]["private"].int {
                                
                                let club = ClubModel(id: id, clubname: clubname, club_pic: club_pic, file_url: file_url, page_no: page_no, privatet: privatet, page_sync: page_sync, host_id: host_id, host_name: host_name, host_profile_pic: host_profile_pic)

                                self.clubList.append(club)
                            }
                            
                            //print(self.clubList.count)
                        }
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        
                        if clubs.count > 0 {
                            
                            self.clubsTableView.isHidden = false
                            self.buttonView.isHidden = false
                            self.clubsTableView.reloadData()
                        } else {
                            self.readingImage.isHidden = false
                            self.readingLabel.isHidden = false
                            self.buttonStack.isHidden = false
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.readingImage.isHidden = false
                        self.readingLabel.isHidden = false
                        self.buttonStack.isHidden = false
                    }
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToClub" {
            if let indexPath = self.clubsTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! ClubViewController
                destinationVC.clubId = clubList[indexPath.row].id
            }
        }
    }
}

//MARK: - Table View Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clubList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClubCell") as! ClubTableViewCell
        let thisClub = clubList[indexPath.row]
        cell.hostLabel.text = thisClub.host_name
        let privacyLabel = thisClub.privatet == 0 ? "Private" : "Public"
        cell.privacyLabel.text = privacyLabel
        cell.titleLabel.text = thisClub.clubname
        cell.clubImageView.image = UIImage(named: "KeatsLeaves")
        //print(thisClub.id)
        if let imgurl = URL.init(string: thisClub.club_pic) {
            cell.clubImageView.loadImage(url: imgurl)
//            self.loadImage(url: imgurl) { [weak self] (image) in
//                guard let self = self, let image = image else { return }
//                cell.clubImageView.loadImage(url: imgurl)
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = clubList[indexPath.row].id
        self.performSegue(withIdentifier: "HomeToClub", sender: self)
    }
    
    
}


