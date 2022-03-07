//
//  UpdateProviderCatgeoryModel.swift
//  Chores for me
//
//  Created by Bright_1 on 17/09/21.
//

import Foundation
struct UpdateProviderCatgeoryModel : Codable {
    let status : Int?
    let data : UpdateProviderCatgeoryModelData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct UpdateProviderCatgeoryModelData : Codable {

}


