//
//  GetReqOnProviderSideModel.swift
//  Chores for me
//
//  Created by Bright_1 on 15/09/21.
//

import Foundation

struct UpdateJobModel : Codable {
    let status : Int?
    let data : UpdateDataModel?
    let message : String?
}
struct UpdateDataModel : Codable {
}



struct GetReqOnProviderSideModel : Codable {
    let status : Int?
    let data : [GetReqOnProviderSideModelData]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct GetReqOnProviderSideModelData : Codable {
    let jobId : Int?
    let userId : String?
    let categoryId : String?
    let categoryName : String?
    let subcategoryId : [SubcategoryId]?
    let image : String?
    let location : String?
    let price : String?
    let description : String?
    let lat : String?
    let lng : String?
    let day : String?
    let time : String?
    let userDetails : UserDetails?
    let jobStatus : String?
    let createdAt : String?
    let booking_date : String?
    let totalTime : String?

    enum CodingKeys: String, CodingKey {

        case jobId = "jobId"
        case userId = "UserId"
        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case subcategoryId = "subcategoryId"
        case image = "image"
        case location = "location"
        case price = "price"
        case description = "description"
        case lat = "lat"
        case lng = "lng"
        case day = "day"
        case time = "time"
        case userDetails = "userDetails"
        case jobStatus = "jobStatus"
        case createdAt = "createdAt"
        case booking_date = "booking_date"
        case totalTime = "totalTime"
    }

}
struct SubcategoryId : Codable {
    let id : String?
    let name : String?
    let price : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case price = "price"
    }
}
struct UserDetails : Codable {
    let userId : Int?
    let name : String?
    let phone : String?
    let image : String?
    let email : String?
    let rating : Float?
    

    enum CodingKeys: String, CodingKey {

        case userId = "UserId"
        case name = "name"
        case phone = "phone"
        case image = "image"
        case email = "email"
        case rating = "rating"
    }
}
