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
    
    var clubList : [Any] = []
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinButtonView.curvedButtonView(color: "KeatsViolet")
        popupJoinButtonView.curvedButtonView(color: "KeatsOrange")
        popupCreateButtonView.curvedButtonView(color: "KeatsOrange")
        clubsTableView.isHidden = true
        buttonView.isHidden = true
        self.popUpOptionView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchClubDetails()
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
                debugPrint(json)
                
                if json["status"] == "success" {
                    let username = json["data"]["user"]["username"]
                    UserDefaults.standard.set(username, forKey: "username")
                    
                    let email = json["data"]["user"]["email"]
                    UserDefaults.standard.set(email, forKey: "email")
                    
                    let profile_pic = json["data"]["user"]["profile_pic"]
                    if let profile_string = profile_pic.rawString() {
                        guard let url = URL(string: profile_string) else {return}
                        
                        DispatchQueue.global().async {
                            guard let data = try? Data(contentsOf: url) else {return }
                            guard let image = UIImage(data: data) else {return }
                            UserDefaults.standard.set(image, forKey: "profile_pic")
                            DispatchQueue.main.async {
                                self.profileImage.image = image
                            }
                        }
                    }
                    
                    UserDefaults.standard.set(profile_pic, forKey: "profile_pic")
                    
                    let bio = json["data"]["user"]["bio"]
                    UserDefaults.standard.set(bio, forKey: "bio")
                    
                    let phone_number = json["data"]["user"]["phone_number"]
                    UserDefaults.standard.set(phone_number, forKey: "phone_number")
                    
                    let id = json["data"]["user"]["id"]
                    UserDefaults.standard.set(id, forKey: "id")
                    
                    let clubs = json["data"]["clubs"]
                    
                    for i in 0...clubs.count-1 {
                        let club_pic = json["data"]["clubs"][i]["club_pic"]
                        let clubname = json["data"]["clubs"][i]["clubname"]
                        let file_url = json["data"]["clubs"][i]["file_url"]
                        let host_id = json["data"]["clubs"][i]["host_id"]
                        let host_name = json["data"]["clubs"][i]["host_name"]
                        let host_profile_pic = json["data"]["clubs"][i]["host_profile_pic"]
                        let id = json["data"]["clubs"][i]["id"]
                        let page_no = json["data"]["clubs"][i]["page_no"]
                        let page_sync = json["data"]["clubs"][i]["page_sync"]
                        let privatet = json["data"]["clubs"][i]["private"]
                        
                        let club = [
                            "club_pic" : club_pic,
                            "clubname" : clubname,
                            "file_url" : file_url,
                            "host_id" : host_id,
                            "host_name" : host_name,
                            "host_profile_pic" : host_profile_pic,
                            "id" : id,
                            "page_no" : page_no,
                            "page_sync" : page_sync,
                            "privatet" : privatet
                        ]
                        
                        self.clubList.append(club)
                        print(self.clubList.count)
                    }
                    
                    if clubs.count > 0 {
                        //
                    }
                    
                }
            }
        }
        task.resume()
    }
//
//    func parseJSON(_ detailsData: Data) -> [ClubModel]?
//    {
//        let decoder = JSONDecoder()
//        
//        var clubList : [ClubModel] = []
//
//        let responseJSON = try? JSONSerialization.jsonObject(with: detailsData, options: [])
//        if let responseJSON = responseJSON as? [String: Any] {
//            print(responseJSON)
//        }
//
//        print("Lets parse...")
//
//        do {
//            let decodedData = try decoder.decode(DetailsData.self, from: detailsData)
//            let status = decodedData.status
//            print("status: \(status)")
//            if status != "error" {
//                let clubs = decodedData.data.clubs
//                print("Club count: \(clubs.count)")
//
//                for i in 0...clubs.count {
//                    let club_pic = decodedData.data.clubs[i].club_pic
//                    let clubname = decodedData.data.clubs[i].clubname
//                    let file_url = decodedData.data.clubs[i].file_url
//                    let host_id = decodedData.data.clubs[i].host_id
//                    let host_name = decodedData.data.clubs[i].host_name
//                    let host_profile_pic = decodedData.data.clubs[i].host_profile_pic
//                    let id = decodedData.data.clubs[i].id
//                    let page_no = decodedData.data.clubs[i].page_no
//                    let page_sync = decodedData.data.clubs[i].page_sync
//                    let privatet = decodedData.data.clubs[i].privatet
//
//                    let club = ClubModel (id: id, clubname: clubname, club_pic: club_pic, file_url: file_url, page_no: page_no, privatet: privatet, page_sync: page_sync, host_id: host_id, host_name: host_name, host_profile_pic: host_profile_pic)
//
//                    clubList.append(club)
//                    print("Appending clublist: \(clubList)")
//                }
//
//                let user = decodedData.data.user
//
//                let bio = decodedData.data.user.bio
//                let email = decodedData.data.user.email
//                let id = decodedData.data.user.id
//                let phone_number = decodedData.data.user.phone_number
//                let profile_pic = decodedData.data.user.profile_pic
//                let username = decodedData.data.user.username
//
//                let userDetails = UserModel (bio: bio, email: email, id: id, phone_number: phone_number, profile_pic: profile_pic, username: username)
//
//
//            }
//        } catch {
//
//        }
//        print("Return clublist: \(clubList)")
//        return clubList
//    }

}


