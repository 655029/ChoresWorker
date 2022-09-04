//
//  SocialSignUpModel.swift
//  Chores for me
//
//  Created by Bright_1 on 16/09/21.
//

import Foundation
struct SocialSignUpModel : Codable {
    let status : Int?
    let data : SocialSignUpData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct SocialSignUpData : Codable {
    let token : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
    }

}


