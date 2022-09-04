//
//  NotificationModel.swift
//  Chores for me
//
//  Created by Mohini's Mac on 28/09/21.
//

import Foundation
struct NotificationModel : Codable {
    let status : Int?
    let data : [NotificationData]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

}
struct NotificationData : Codable {
    let id : Int?
    let user_id : Int?
    let job_id : Int?
    let text : String?
    let type : String?
    let provider_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case job_id = "job_id"
        case text = "text"
        case type = "type"
        case provider_id = "provider_id"
    }
}
