//
//  ResetPasswordModel.swift
//  Chores for me
//
//  Created by Bright_1 on 15/09/21.
//

import Foundation
struct ResetPasswordModel : Codable {
    let status : Int?
    let data : ResetPasswordModelData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct ResetPasswordModelData : Codable {

}
