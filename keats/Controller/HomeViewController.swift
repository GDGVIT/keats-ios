//
//  HomeViewController.swift
//  keats
//
//  Created by Swamita on 04/04/21.
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var readingImage: UIImageView!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var buttonStack: UIStackView!
    
    @IBOutlet weak var joinButtonView: UIView!
    var clubList : [ClubModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinButtonView.layer.cornerRadius = 4
        joinButtonView.layer.borderWidth = 1
        joinButtonView.layer.borderColor = UIColor(named: "KeatsViolet")?.cgColor
        //fetchClubDetails()
    }
    
    func fetchClubDetails() {
        let url = URL(string: "https://keats-testing.herokuapp.com/api/user/clubs")
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "JWToken") else {return}
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data {
                if let clubs = self.parseJSON(data) {
                    self.clubList = clubs
                    print(clubs)
                    
                    
                }
                
            }
        }
        task.resume()
    }
    
    func parseJSON(_ detailsData: Data) -> [ClubModel]?
    {
        let decoder = JSONDecoder()
        
        var clubList : [ClubModel] = []
        
        print("Lets parse...")

        do {
            let decodedData = try decoder.decode(DetailsData.self, from: detailsData)
            let status = decodedData.status
            print("status: \(status)")
            if status != "error" {
                let clubs = decodedData.data.clubs
                print("Club count: \(clubs.count)")
                
                for i in 0...clubs.count {
                    let club_pic = decodedData.data.clubs[i].club_pic
                    let clubname = decodedData.data.clubs[i].clubname
                    let file_url = decodedData.data.clubs[i].file_url
                    let host_id = decodedData.data.clubs[i].host_id
                    let host_name = decodedData.data.clubs[i].host_name
                    let host_profile_pic = decodedData.data.clubs[i].host_profile_pic
                    let id = decodedData.data.clubs[i].id
                    let page_no = decodedData.data.clubs[i].page_no
                    let page_sync = decodedData.data.clubs[i].page_sync
                    let privateBool = decodedData.data.clubs[i].privateBool
                    
                    let club = ClubModel (id: id, clubname: clubname, club_pic: club_pic, file_url: file_url, page_no: page_no, privateBool: privateBool, page_sync: page_sync, host_id: host_id, host_name: host_name, host_profile_pic: host_profile_pic)
                    
                    clubList.append(club)
                    print("Appending clublist: \(clubList)")
                }
                
                //let user = decodedData.data.user
                
//                let bio = decodedData.data.user.bio
//                let email = decodedData.data.user.email
//                let id = decodedData.data.user.id
//                let phone_number = decodedData.data.user.phone_number
//                let profile_pic = decodedData.data.user.profile_pic
//                let username = decodedData.data.user.username
                
//                let userDetails = UserModel (bio: bio, email: email, id: id, phone_number: phone_number, profile_pic: profile_pic, username: username)
                
                
            }
        } catch {
            
        }
        print("Return clublist: \(clubList)")
        return clubList
    }

}
