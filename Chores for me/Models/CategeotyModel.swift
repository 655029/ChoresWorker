//
//  CategeotyModel.swift
//  Chores for me
//
//  Created by Bright_1 on 01/09/21.
//

import Foundation

struct CategoryListModel : Codable {
    let status : Int?
    let data : [CategoryListData]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct CategoryListData : Codable {
    let categoryId : Int?
    let categoryName : String?
    let categoryImage : String?

    enum CodingKeys: String, CodingKey {

        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case categoryImage = "categoryImage"
    }

}
