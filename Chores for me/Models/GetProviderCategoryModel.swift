//
//  GetProviderCategoryModel.swift
//  Chores for me
//
//  Created by Arzoo Mac on 21/10/21.
//

import Foundation
struct GetProviderCategoryModel : Codable {
    let status : Int?
    let data : GetProviderCategoryModelData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
struct GetProviderCategoryModelData : Codable {
    let id : Int?
    let providerId : String?
    let categoryId : String?
    let categoryName : String?
    let subcategoryId : String?
    let subcategoryName : String?
    let subcategoryPrice : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case providerId = "providerId"
        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case subcategoryId = "subcategoryId"
        case subcategoryName = "subcategoryName"
        case subcategoryPrice = "subcategoryPrice"
        case createdAt = "createdAt"
    }



}

