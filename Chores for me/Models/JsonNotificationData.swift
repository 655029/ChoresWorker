//
//  JsonNotificationData.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 07/10/21.
//


import Foundation
struct JsonNotificationDataModel : Codable {
    let status : Int?
    let data : JsonNotificationData?
    let jobId : String?
    let message : String?
}
struct JsonNotificationData : Codable {
    let jobId : Int?
    let UserId : String?
    let categoryId : String?
    let categoryName : String?
    let subcategoryId : [SubcategoryIdData]?
    let image : String?
    let location : String?
    let price : String?
    let description : String?
    let lat : String?
    let lng : String?
    let day : String?
    let time : String?
    let jobStatus : String?
    let createdAt : String?
    let booking_date : String?
    let userDetails : UserDetailsData?
    let providerDetails : ProviderDetails?
    let first_name: String?
}


struct ProviderDetails : Codable {
    let UserId : Int?
    let name : String?
    let first_name: String?
    let email : String?
    let phone : String?
    let otp : String?
    let image : String?
    let user_verified : Int?
    let signupType : Int?
    let socialKey : String?
    let lat : String?
    let lng : String?
    let location_address : String?
    let radius : String?
    let availability_provider_days : String?
    let availability_provider_timing : String?
    let deviceID : String?
    let deviceType : String?
    let createdAt : String?
    let rating : Float?
    let booking_date : String?

}
struct SubcategoryIdData : Codable {
    let id : String?
    let name : String?
    let price : String?
}
struct UserDetailsData : Codable {
    let UserId : Int?
    let name : String?
    let first_name: String?
    let email : String?
    let phone : String?
    let otp : String?
    let image : String?
    let user_verified : Int?
    let signupType : Int?
    let socialKey : String?
    let lat : String?
    let lng : String?
    let location_address : String?
    let radius : String?
    let availability_provider_days : String?
    let availability_provider_timing : String?
    let deviceID : String?
    let deviceType : String?
    let createdAt : String?
    let booking_date : String?
}
