//
//  RegisterModel.swift
//  Chores for me
//
//  Created by Bright_1 on 23/08/21.
//

import Foundation


struct RegisterModel : Codable {
    let status : Int?
    let data : RegisterData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}

struct RegisterData : Codable {

}
