//
//  ForgotPasswordModel.swift
//  Chores for me
//
//  Created by Bright_1 on 09/09/21.
//

import Foundation
struct ForgotPasswordModel: Codable {
    let status : Int?
    let data : ForgotPasswordData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct ForgotPasswordData : Codable {
    let oTP : String?

    enum CodingKeys: String, CodingKey {

        case oTP = "OTP"
    }
}
