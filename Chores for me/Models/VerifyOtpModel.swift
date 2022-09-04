//
//  VerifyOtpModel.swift
//  Chores for me
//
//  Created by Bright_1 on 24/08/21.
//

import Foundation
struct VerifyOtpModel : Codable {
    let status : Int?
    let data : VerifyOtpData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct VerifyOtpData : Codable {
    let token : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
    }
}
