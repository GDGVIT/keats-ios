//
//  DetailsModel.swift
//  keats
//
//  Created by Swamita on 05/04/21.
//

import Foundation

struct DetailsModel {
    var status : String
    var data : DetailsDataModel
}

struct DetailsDataModel {
    var clubs : [ClubModel]
    var user: UserModel
}

struct DetailsData: Codable {
    var status : String
    var data : DetailsDataData
}

struct DetailsDataData: Codable {
    var clubs : [ClubData]
    var user: UserData
}
