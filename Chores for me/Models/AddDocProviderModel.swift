//
//  AddDocProviderModel.swift
//  Chores for me
//
//  Created by Bright_1 on 28/08/21.
//

import Foundation
struct ProvideDocumentsModel : Codable {
    let status : Int?
    let data : ProvidrData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct ProvidrData : Codable {

    //enum CodingKeys: String, CodingKey {

    //}
}
