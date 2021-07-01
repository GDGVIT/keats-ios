//
//  JoinClubViewController.swift
//  keats
//
//  Created by Swamita on 04/05/21.
//

import UIKit
import SwiftyJSON
import AVFoundation

class JoinClubViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var clubsTableView: UITableView!
    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var clubList : [ClubModel] = []
    var clubId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarColor(view: view)
        clubsTableView.delegate = self
        clubsTableView.dataSource = self
        clubsTableView.isHidden = true
        publicLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getPublicClubs()
        //joinClub(code: "13355952-5b2c-4608-8c52-defe15e67cf4")
        clubsTableView.register(UINib(nibName: "ClubTableViewCell", bundle: nil), forCellReuseIdentifier: "ClubCell")

    }
    
    @IBAction func qrTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    @IBAction func joinTapped(_ sender: Any) {
        guard let clubCode = codeTextField.text else { return}
        if clubCode == "" {
            alert(message: "Type or scan the club's code to join.", title: "Empty Field")
        } else {
            joinClub(code: clubCode)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - QR Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let qrcodeImg = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
                let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                let ciImage:CIImage=CIImage(image:qrcodeImg)!
                var qrCodeLink=""
      
                let features=detector.features(in: ciImage)
                for feature in features as! [CIQRCodeFeature] {
                    qrCodeLink += feature.messageString!
                }
                
                if qrCodeLink=="" {
                    print("nothing")
                }else{
                    print("message: \(qrCodeLink)")
                    codeTextField.text = qrCodeLink
                }
            }
            else{
               print("Something went wrong")
            }
           self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Join Club
    
    func joinClub(code: String) {
        
        let json: [String: Any] = ["club_id": code]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        guard let url = URL(string: "https://keats-testing.herokuapp.com/api/clubs/join") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        
        guard let token = UserDefaults.standard.string(forKey: "JWToken") else {
            return}
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
                    let data = responseJSON["data"]
                    if let data = data as? [String: Any] {
                        let club = data["club"]
                        if let club = club as? [String: Any] {
                            let id = club["id"]
                            if let id = id as? String {
                                self.clubId = id
                                DispatchQueue.main.async {
//                                    let destinationVC = ClubViewController()
//                                    destinationVC.clubId = id
                                    print("id: \(id)")
                                    self.performSegue(withIdentifier: "JoinToClub", sender: self)
                                }
                            }
                        }
                    }
                    
                } else {
                    if let message = responseJSON["message"] as? String, let status = responseJSON["status"] as? String {
                        DispatchQueue.main.async {
                            self.alert(message: message, title: status)
                        }
                    }
                    
                }
                //print(responseJSON)
            }
        }

        task.resume()

    }
    
    //MARK: - Get Public Clubs
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = clubList[indexPath.row].id
        print(id)
        joinClub(code: id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ClubViewController {
            let vc = segue.destination as? ClubViewController
            vc?.clubId = clubId
            print("clubId: \(clubId)")
        }
    }
    
}

