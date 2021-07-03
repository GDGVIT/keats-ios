//
//  leaveClub.swift
//  keats
//
//  Created by Swamita on 03/07/21.
//

import Foundation
import UIKit

extension ClubViewController {
    
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
                            print("Club Left")
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
}
