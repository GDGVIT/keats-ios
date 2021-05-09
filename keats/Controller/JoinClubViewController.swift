//
//  JoinClubViewController.swift
//  keats
//
//  Created by Swamita on 04/05/21.
//

import UIKit
import SwiftyJSON

class JoinClubViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var clubsTableView: UITableView!
    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var clubList : [ClubModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubsTableView.delegate = self
        clubsTableView.dataSource = self
        clubsTableView.isHidden = true
        publicLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getPublicClubs()
        clubsTableView.register(UINib(nibName: "ClubTableViewCell", bundle: nil), forCellReuseIdentifier: "ClubCell")

    }
    
    @IBAction func qrTapped(_ sender: Any) {
    }
    
    @IBAction func joinTapped(_ sender: Any) {
        if codeTextField.text != "" {
            
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getPublicClubs() {
        let url = URL(string: "https://keats-testing.herokuapp.com/api/clubs/list")
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "JWToken") else {
            return}
        
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

                    let clubs = json["data"]
                    //print("Club count: \(clubs.count)")
                    
                    if clubs.count > 0 {
                        for i in 0...clubs.count-1 {
                            if let club_pic = json["data"][i]["club_pic"].rawString(),
                            let clubname = json["data"][i]["clubname"].rawString(),
                            let file_url = json["data"][i]["file_url"].rawString(),
                            let host_id = json["data"][i]["host_id"].rawString(),
                            let host_name = json["data"][i]["host_name"].rawString(),
                            let host_profile_pic = json["data"][i]["host_profile_pic"].rawString(),
                            let id = json["data"][i]["id"].rawString(),
                            let page_no = json["data"][i]["page_no"].int,
                            let page_sync = json["data"][i]["page_sync"].bool,
                            let privatet = json["data"][i]["private"].int {

                                let club = ClubModel(id: id, clubname: clubname, club_pic: club_pic, file_url: file_url, page_no: page_no, privatet: privatet, page_sync: page_sync, host_id: host_id, host_name: host_name, host_profile_pic: host_profile_pic)

                                self.clubList.append(club)
                            }

                            //print(self.clubList.count)
                        }
                    }

                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
//
                        if clubs.count > 0 {
                            self.clubsTableView.isHidden = false
                            print(self.clubList)
                            self.clubsTableView.reloadData()
                        } else {
                            self.publicLabel.isHidden = false
                        }
                    }

                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.publicLabel.isHidden = false
                    }
                }
            }
        }
        task.resume()
    }
}

extension JoinClubViewController: UITableViewDelegate, UITableViewDataSource {
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
        print(thisClub.id)
        if let imgurl = URL.init(string: thisClub.club_pic) {
            cell.clubImageView.loadImage(url: imgurl)
//            self.loadImage(url: imgurl) { [weak self] (image) in
//                guard let self = self, let image = image else { return }
//                cell.clubImageView.loadImage(url: imgurl)
//            }
        }
        
        return cell
    }
    
    
}
