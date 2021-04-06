//
//  UserModel.swift
//  keats
//
//  Created by Swamita on 05/04/21.
//

import Foundation

struct UserModel {
    var bio: String
    var email: String
    var id: String
    var phone_number: String
    var profile_pic: String
    var username: Int
}

struct UserData : Codable {
    var bio: String
    var email: String
    var id: String
    var phone_number: String
    var profile_pic: String
    var username: Int
}
