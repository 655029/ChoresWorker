//
//  LoginModel.swift
//  
//
//  Created by Bright_1 on 24/08/21.
//

import Foundation

struct LoginModel : Codable {
    let status : Int?
    let data : LoginData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }


}
struct LoginData : Codable {
    let token : String?
    let docStatus : String?
    let user_verified : Int?
    let phone : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
        case docStatus = "docStatus"
        case user_verified = "user_verified"
        case phone = "phone"
    }
}
