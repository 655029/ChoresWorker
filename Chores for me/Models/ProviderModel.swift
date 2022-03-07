//
//  ProviderModel.swift
//  Chores for me
//
//  Created by Bright_1 on 30/09/21.
//

import Foundation
struct ProviderModel : Codable {
    let status : Int?
    let data : providerVerifyData?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }
}
    struct providerVerifyData : Codable {
        let docId : Int?
        let provider_ID : String?
        let proof_image1 : String?
        let proof_image2 : String?
        let proof_ID : String?
        let work_exp : String?
        let exp_desciption : String?
        let proof_image_one_status : String?
        let proof_image_two_status : String?
        let createdAt : String?

        enum CodingKeys: String, CodingKey {

            case docId = "docId"
            case provider_ID = "provider_ID"
            case proof_image1 = "proof_image1"
            case proof_image2 = "proof_image2"
            case proof_ID = "proof_ID"
            case work_exp = "work_exp"
            case exp_desciption = "exp_desciption"
            case proof_image_one_status = "proof_image_one_status"
            case proof_image_two_status = "proof_image_two_status"
            case createdAt = "createdAt"
        }


}
