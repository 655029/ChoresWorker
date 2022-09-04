//
//  ApiSwiftFile.swift
//  Chores for me
//
//  Created by Bright_1 on 23/08/21.
//

import Foundation
import UIKit
class DataBasemanager {
    static let shareInstance = DataBasemanager()
    var urlRequest:URLRequest!
    var taskObj:URLSessionDataTask!
    func database(){
    urlRequest = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/signup")!)
    urlRequest.httpMethod = "POST"
        let dataToPost = "email=\(UITextField.self)&registeredPassword=\(UITextField.self)&funcName=verifyLogin"
    urlRequest.httpBody = dataToPost.data(using: String.Encoding.utf8)
    taskObj = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [self] (data, details, err) in
        if (err == nil)
        {
            print("sucess")
            print(data as Any)
            do {
                let dataConverted = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : String]
                print(dataConverted)
                DispatchQueue.main.sync {
                    if (dataConverted["loggedIn"] == "yes") {
                        print("sucess")
                }
                }
            } catch{
                print("wrong")
            }
        }
    })
    self.taskObj.resume()
}
}
