//
//  HomeViewController.swift
//  keats
//
//  Created by Swamita on 04/04/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchClubDetails()
    }
    
    func fetchClubDetails() {
        let url = URL(string: "https://keats-testing.herokuapp.com/api/user/clubs")
        guard let requestUrl = url else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        //guard let token = UserDefaults.standard.string(forKey: "IDToken") else { return}
        
        //request.setValue(token, forHTTPHeaderField: "Authorization")
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImU5ZTMzZTA4LTcwMDgtNDU1My1iODJiLTM3M2NiNDc0ODAzYyJ9.hPGBTjm93Zi4H5xsIFsGFLxoN-OuZJgsVmPYtXF-kKQ"
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            if let data = data {
                //print("Response data string:\n \(dataString)")
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            
            
        }
        task.resume()
    }

}
