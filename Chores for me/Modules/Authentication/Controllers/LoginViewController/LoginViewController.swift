//
//  LoginViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Designable
import CoreLocation

protocol socialLogin_Delegate{
    func social_login(email: String, type: socialLoginType, token: String,deviceType:String, deviceId: String, phoneNumber: String)
    
    func phone_Verification()
    
    func emailPsswordUserCreadted()
}

enum socialLoginType: String {
    case facebook , google , email
}

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: DesignableButton!
    @IBOutlet weak var googleLoginButton: DesignableButton!
    @IBOutlet weak var appleLoginButton: DesignableButton!
    @IBOutlet weak var showAndHidePasswordButton: UIButton!
    
    // MARK: - Properties
    var GoogleLogin: gmail_LoginDelegate!
    var FacebookLogin: facebookLogin_delegate!
    var iconClick: Bool = true
    var socailKey = [String]()
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        applyDesigns()
        
        if UserStoreSingleton.shared.fcmToken == nil || UserStoreSingleton.shared.fcmToken == "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let app = UIApplication.shared
            appDelegate.registerLocal(application: app)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Layout
    
    private func applyDesigns() {
        facebookLoginButton.addSpaceBetweenImageAndTitle(spacing: 6)
        googleLoginButton.addSpaceBetweenImageAndTitle(spacing: 6)
        let imageView = UIImage(named: "square-with-round")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButton.setImage(imageView, for: .normal)
        let imageView2 = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButton.setImage(imageView2, for: .selected)
        showAndHidePasswordButton.tintColor = .white
    }
    
    // MARK: - User Interaction
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if  emailTextField.text == ""{
            openAlert(title: "Chores for me", message: "Please fill Email ", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        } else if !emailTextField.text!.isValidEmail{
            openAlert(title: "Chores for me", message: "Please fill Email", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                
            }])
        }
        else if passwordTextField.text?.isEmpty == true {
            openAlert(title: "Chores for me ", message: " Please Enter Password", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        }
        else {
            if Reachability.isConnectedToNetwork(){
                userLogin()
            }else{
                openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    
                }])
            }
        }
    }
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        navigate(.forgotPassword)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        navigate(.register)
    }
    
    @IBAction func showAndHidePasswordButtonAction(_ sender: UIButton) {
        //        if (iconClick ==  true) {
        //            passwordTextField.isSecureTextEntry = false
        //        }
        //        else {
        //            passwordTextField.isSecureTextEntry = true
        //        }
        //        iconClick = !iconClick
        //        showAndHidePasswordButton.isSelected.toggle()
        showAndHidePasswordButton.isSelected = !showAndHidePasswordButton.isSelected
        passwordTextField.isSecureTextEntry = !showAndHidePasswordButton.isSelected
        
    }
    
    @IBAction func btn_Facebook(_ sender: UIButton) {
        FacebookLogin = facebookLogin_delegate(delegate: self, viewController: self)
    }
    
    @IBAction func btn_Google(_ sender: UIButton) {
        GoogleLogin = gmail_LoginDelegate(delegate: self, viewController: self)
    }
    
    
    // MARK: - Additional Helpers
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            break
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    func userLogin() {
        //start loader here
        showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/login") else { return }
        //print(gitUrl)
        
        let request = NSMutableURLRequest(url: gitUrl)
        
        let parameters = [
            "email" :emailTextField.text ?? "",
            "password": passwordTextField.text ?? "",
            "signupType":"1",
            "deviceID":UserStoreSingleton.shared.fcmToken ?? "",
            "deviceType":1,
        ] as [String : Any]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(LoginModel.self, from: data)
                print("response data:", gitData)
                UserStoreSingleton.shared.isLoggedIn = true
                DispatchQueue.main.async {
                    self.hideActivity()
                    if gitData.status == 200 {
                        let phoneNumber = gitData.data?.phone
                        let headersvalue = gitData.data?.token
                        let docStatus = gitData.data?.docStatus
                        if gitData.data?.user_verified == 0{
                            self.sendOtp()
                            self.navigate(.twosetpVerification)
                        }else{ 
                            UserStoreSingleton.shared.Token = headersvalue
                            UserStoreSingleton.shared.phoneNumer = phoneNumber
                            UserStoreSingleton.shared.email = self.emailTextField.text
                            UserStoreSingleton.shared.pass = self.passwordTextField.text
                            self.getUserProfile()
                            if docStatus == "" {
                                self.navigate(.chooseYourCity)
                            }else{
                                if UserStoreSingleton.shared.isLocationEnbled == true {
                                    RootRouter().loadMainHomeStructure()
                                }
                                else {
                                    self.navigate(.allowLocation)
                                }
                            }
                        }
                    } else{
                         self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                self.hideActivity()
                self.showMessage("error occured")
                print("Err", err)
            }
        }.resume()
    }
        
    
    func getUserProfile(){
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetUserProfileModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    UserStoreSingleton.shared.name = json.data?.first_name
                    UserStoreSingleton.shared.lastname = json.data?.last_name
                    UserStoreSingleton.shared.profileImage = json.data?.image
                    UserStoreSingleton.shared.userID = json.data?.userId
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func sendOtp(){
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/sendOtp") else { return }
        print(gitUrl)

        let request = NSMutableURLRequest(url: gitUrl)
        let phoneNumber = "\(UserStoreSingleton.shared.Dialcode ?? "")\(UserStoreSingleton.shared.phoneNumer ?? "")"
        let parameters = ["phone": phoneNumber,"signupType": "1"]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        session.dataTask(with: request as URLRequest) { [self] data, response, error in

            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(SendOtpModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    UserStoreSingleton.shared.OtpCode = gitData.data?.oTP
                    if gitData.status == 200{
                        showMessage(gitData.message ?? "")
                    } else{
                        showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                self.hideActivity()
                print("Err", err)
            }
        }.resume()
    }
}
func socialSignInAPI(){
    guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/social-signIn") else { return }
    let request = NSMutableURLRequest(url: gitUrl)
    let parameters = ["socialKey": RegisterViewController.socialKey,"signupType":"1"]
    let session = URLSession.shared
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
    
    session.dataTask(with: request as URLRequest) { data, response, error in
        
        guard let data = data else { return }
        do {
            let gitData = try JSONDecoder().decode(SocialSignInModel.self, from: data)
            print("response data:", gitData)
            DispatchQueue.main.async {
                let phoneNumber = gitData.data?.phone
                let headersvalue = gitData.data?.token
                let responseMessage = gitData.status
                if responseMessage == 200 {
                    UserStoreSingleton.shared.isLoggedIn = true
                    UserStoreSingleton.shared.Token = headersvalue
                    UserStoreSingleton.shared.phoneNumer = phoneNumber
                    UserStoreSingleton.shared.userToken = gitData.data?.token
                    RootRouter().loadMainHomeStructure()
                }
                else{
                  //  self.showMessage(gitData.message ?? "")

                }

            }
            
        } catch let err {
            print("Err", err)
        }
    }.resume()
}

extension LoginViewController : socialLogin_Delegate {
    func social_login(email: String, type: socialLoginType, token: String, deviceType: String, deviceId: String, phoneNumber: String) {
        socialSignInAPI()
        print(token)
        
    }
    
    func phone_Verification() {
        print("Phone")
    }
    
    func emailPsswordUserCreadted() {
        print("Email")
    }
    
    
}




