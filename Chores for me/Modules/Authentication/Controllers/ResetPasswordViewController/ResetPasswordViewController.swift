//
//  ResetPasswordViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Alamofire

class ResetPasswordViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
   
   
    // MARK: - Layout
    
    // MARK: - User Interaction
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordButtonAction(_ sender: Any) {
        if passwordTextField.text == "" {
            openAlert(title: "Chores for me", message: "Please Enter  Paswword", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        }
        else if !passwordTextField.text!.isPasswordValid {
            openAlert(title: "Chores for me", message: "Invalid Password Should contain 7 Characters, including UPPER/lowercase and numbers", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        }
        else if confirmPasswordTextField.text == "" {
            openAlert(title: "Chores for me", message: "Please Enter  confirmPassword", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        }
        else if confirmPasswordTextField.text != passwordTextField.text {
            openAlert(title: "Chores for me", message: " Password and Confirm Password Are Not Equal", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        }
        else   {
            if Reachability.isConnectedToNetwork(){
                resetPassword()
            }else{
                openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    
                }])
            }
        }
    }
    
    // MARK: - Additional Helpers
    
    func resetPassword(){
        let Url = String(format: "http://3.18.59.239:3000/api/v1/reset-password")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary =  ["email":"\(UserStoreSingleton.shared.email ?? "")","password":passwordTextField.text ?? "","newPassword":confirmPasswordTextField.text ?? ""]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do {
                let json =  try JSONDecoder().decode(ResetPasswordModel.self, from: data)
                DispatchQueue.main.async{
                    if json.status == 200 {
                        self.showMessage(json.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                            let isLogin = UserStoreSingleton.shared.isLoggedIn
                            if(isLogin ?? false){
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                self.navigate(.login)
                            }
                        }
                    } else{
                        self.showMessage(json.message ?? "")
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

// MARK: - UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            // Reset password action
            break
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

