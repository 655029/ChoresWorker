//
//  RatingsAPI.swift
//  Chores for me
//
//  Created by Bright_1 on 17/09/21.
//

import UIKit
import Foundation

class UserSingletonRatingsAPI: NSObject {
    static let shared = UserSingletonRatingsAPI()
    let parameters = ["userID":12,
                      "ratingType":0,
                      "providerID":10,
                      "jobID":25,
                      "ratings":4.3,
                      "comments":"Good work!,Well done"] as [String : Any]
    let url = URL(string: "http://3.18.59.239:3000/api/v1/ratings")
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    //  print("Token is",UserStoreSingleton.shared.Token)
    request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
        return
    }
    request.httpBody = httpBody
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        if let Apiresponse = response {
            debugPrint(Apiresponse)
        }
        if let data = data {
            do {
                _ =  try JSONDecoder().decode(UpdateProviderCatgeoryModel.self, from: data)
                DispatchQueue.main.async{
                    
                }
                
            }catch{
            }
        }
    }.resume()
}


