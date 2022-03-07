//
//  Alamofire.swift
//  Chores for me
//
//  Created by Bright_1 on 23/08/21.
//

import Foundation
import Alamofire
import UIKit
class ApiManger {
    static let shareInstace = ApiManger()
    func callingApi(register:RegisterSignup) {
        AF.request(base_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: )
        
    }
}
