//
//  ForgotPasswordViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var backButon: UIButton!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    // MARK: - Properties
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  navigationController?.navigationBar.isHidden = false
        let image = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButon.setImage(image, for: .normal)
        backButon.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // navigationController?.navigationBar.isHidden = true
        
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let email = emailTextField.text!
        if  !email.isValidEmail {
            openAlert(title: "Chores for me", message: "Invalid Email Address", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        }else{
            if Reachability.isConnectedToNetwork(){
                callingForgotPasswordAPI()
            }else{
                openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    
                }])
            }
        }
        
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Additional Helpers
    func callingForgotPasswordAPI() {
        showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/forgot-password") else { return }
        // print(gitUrl)
        let request = NSMutableURLRequest(url: gitUrl)
        let parameters = ["email": emailTextField.text ?? ""]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(ForgotPasswordModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let responseMeaassge = gitData.status
                    self.showMessage(gitData.message ?? "")
                    if responseMeaassge == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                        self.navigate(.forgotPasswordOTP)
                        }
                    }
                    else{
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
}
