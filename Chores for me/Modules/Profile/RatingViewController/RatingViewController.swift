//
//  RatingViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit

class RatingViewController: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var bacgroundImage: UIImageView!
    @IBOutlet var view_Rating: FloatRatingView!
    @IBOutlet weak var textView: UITextView!
    var rData:NotificationData!
    var imge = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(rData)
       
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.darkGray.cgColor
        navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewDidLayoutSubviews() {
        bacgroundImage.image = imge
    }
    @IBAction func btn_Skip(_ sender: UIButton) {
       dismiss(animated: false, completion: nil)
       // dismiss(animated: true)
    }
    @IBAction func btn_Submit(_ sender: UIButton) {
        if view_Rating.rating.isLess(than: 1.0) {
            showMessage("Please Rate Again!")
        } else {
            ratingAPI()
        }
    }
    
    func ratingAPI(){
        // showActivity()
        let parameters = [ "userID": rData.user_id  ?? "",
                           "ratingType":1,
                           "providerID": rData.provider_id ?? "",
                           "jobID":rData.job_id!,
                           "ratings": view_Rating.rating,
                           "comments": textView.text ?? ""] as [String : Any]
        let url = URL(string: "http://3.18.59.239:3000/api/v1/ratings")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(RatingModel.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        if json.status == 200 {
                            self.showMessage(json.message ?? "")
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                                self.navigationController?.popViewController(animated: true)
                           }
                           
                        }else{
                            self.showMessage(json.message ?? "")
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                                self.navigationController?.popViewController(animated: true)
                           }
                        }
                    }
                }catch{
                }
            }
        }.resume()
    }
}
