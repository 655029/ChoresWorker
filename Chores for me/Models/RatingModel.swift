//
//  RatingModel.swift
//  Chores for me
//
//  Created by Bright_1 on 04/10/21.
//

import Foundation
struct RatingModel : Codable {
    let status : Int?
    let data : RatingData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

    
}
struct RatingData : Codable {
}

