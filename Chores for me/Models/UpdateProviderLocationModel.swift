//
//  UpdateProviderLocationModel.swift
//  Chores for me
//
//  Created by Bright_1 on 16/09/21.
//

import Foundation
struct UpdateLocationModel : Codable {
    let status : Int?
    let data : Data?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct UpdateLocationData : Codable {
}
