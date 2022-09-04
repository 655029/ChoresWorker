//
//  SocialSignInModel.swift
//  Chores for me
//
//  Created by Bright_1 on 16/09/21.
//

import Foundation
struct SocialSignInModel : Codable {
    let status : Int?
    let data : SocialSignInData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct SocialSignInData : Codable {
    let token : String?
    let phone : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
        case phone = "phone"
    }

  

}
