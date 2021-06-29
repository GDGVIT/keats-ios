//
//  prepareRequest.swift
//  keats
//
//  Created by Swamita on 30/06/21.
//

import Foundation

func prepareRequest(method: String, url: URL, jsonData: Data?) {
    var request = URLRequest(url: url)
    request.httpMethod = method
    
    guard let token = UserDefaults.standard.string(forKey: "JWToken") else {return}
    print("Bearer \(token)")
    
    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // insert json data to the request
    request.httpBody = jsonData
    
    let tsk = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let dta = data, error == nil else {
            print(error?.localizedDescription ?? "no data")
            return
        }
        
        let responseJSON = try? JSONSerialization.jsonObject(with: dta, options: [])
        if let rsponseJSON = responseJSON as? [String: Any] {
            let status = rsponseJSON["status"]
            if status as! String != "error" {
                print("Successfully updated data")
            } else {
                print(rsponseJSON)
            }
        }
    }
    
    tsk.resume()
}
