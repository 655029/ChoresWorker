//
//  SubCatgeoryModel.swift
//  Chores for me
//
//  Created by Bright_1 on 31/08/21.
//

import Foundation
struct SubCatgeoryModel : Codable {
    let status : Int?
    let data : [SubCatgeoryModelData]?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct SubCatgeoryModelData : Codable {
    let subcategoryId : Int?
    let categoryId : String?
    let subcategoryName : String?
    let subcategoryImage : String?
    let status : String?
    var checked: Bool?
    var price : String?
    
    enum CodingKeys: String, CodingKey {
        
        case subcategoryId = "subcategoryId"
        case categoryId = "categoryId"
        case subcategoryName = "subcategoryName"
        case subcategoryImage = "subcategoryImage"
        case status = "status"
    }
}

