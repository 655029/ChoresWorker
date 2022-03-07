//
//  SendOtpModel.swift
//  Chores for me
//
//  Created by Bright_1 on 24/08/21.
//

import Foundation
struct SendOtpModel : Codable {
    let status : Int?
    let data : SendOtpData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct SendOtpData : Codable {
    let oTP : String?

    enum CodingKeys: String, CodingKey {

        case oTP = "OTP"
    }
}
