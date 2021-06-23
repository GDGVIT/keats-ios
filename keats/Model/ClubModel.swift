//
//  ClubModel.swift
//  keats
//
//  Created by Swamita on 05/04/21.
//

import Foundation
import UIKit.UIImage

struct ClubModel {
    var id: String
    var clubname: String
    var club_pic: String
    var file_url: String
    var page_no: Int
    var privatet: Int
    var page_sync: Bool
    var host_id: String
    var host_name: String
    var host_profile_pic: String
    
//    var clubImage: UIImage? {
//        guard let imgurl = URL.init(string: club_pic) else {return}
//        
//            DispatchQueue.global().async { [self] in
//                if let data = try? Data(contentsOf: imgurl) {
//                    return UIImage(data: data)
//                }
//            }
//        
//    }
}

struct ClubData : Codable {
    var id: String
    var clubname: String
    var club_pic: String
    var file_url: String
    var page_no: Int
    var privatet: Int
    var page_sync: Bool
    var host_id: String
    var host_name: String
    var host_profile_pic: String
}
