//
//  ClubModel.swift
//  keats
//
//  Created by Swamita on 05/04/21.
//

import Foundation

struct ClubModel {
    var id: String
    var clubname: String
    var club_pic: String
    var file_url: String
    var page_no: Int
    var privateBool: Bool
    var page_sync: Bool
    var host_id: String
    var host_name: String
    var host_profile_pic: String
}

struct ClubData : Codable {
    var id: String
    var clubname: String
    var club_pic: String
    var file_url: String
    var page_no: Int
    var privateBool: Bool
    var page_sync: Bool
    var host_id: String
    var host_name: String
    var host_profile_pic: String
}
