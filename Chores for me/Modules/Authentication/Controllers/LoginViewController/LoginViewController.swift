//
//  LoginViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Designable
import CoreLocation
import FBSDKLoginKit
import GoogleSignIn


class LoginViewController: BaseViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: DesignableButton!
    @IBOutlet weak var googleLoginButton: DesignableButton!
    @IBOutlet weak var appleLoginButton: DesignableButton!
    @IBOutlet weak var showAndHidePasswordButton: UIButton!
    
    
    // MARK: - Properties
    var iconClick: Bool = true
    var socailKey = [String]()
    var mainSocailKey: String?
    static var googleLoginName: String?
    static var googleLoginLastName: String?
    static var googleLoginImage: String?
    

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
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
        GIDSignIn.sharedInstance()?.presentingViewController = self
        navigationController?.navigationBar.isHidden = true
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    // MARK: - Layout
    private func applyDesigns() {
        self.facebookLogin()
        self.googleLogin()
        facebookLoginButton.addSpaceBetweenImageAndTitle(spacing: 6)
        googleLoginButton.addSpaceBetweenImageAndTitle(spacing: 6)
        let imageView = UIImage(named: "square-with-round")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButton.setImage(imageView, for: .normal)
        let imageView2 = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButton.setImage(imageView2, for: .selected)
        showAndHidePasswordButton.tintColor = .white
        facebookLoginButton.addTarget(self, action: #selector(didTappedFacebookButton(_:)), for: .touchUpInside)
    }
    
    
    private func facebookLogin() {
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
    }
    
    private func googleLogin() {
        GIDSignIn.sharedInstance().presentingViewController = self
//        if GIDSignIn.sharedInstance().hasPreviousSignIn() {
//            print("Allresdy Login")
//            print(GIDSignIn.sharedInstance().restorePreviousSignIn())
//        }
        
    }
    
    // MARK: - User Interaction
    @objc func didTappedFacebookButton(_ sender: DesignableButton) {
        self.getFacebookUserInfo()
        
    }
    
     private func getFacebookUserInfo() {
         self.showActivity()
            let loginManager = LoginManager()
         self.hideActivity()
                loginManager.logIn(permissions: ["email","public_profile"], from: self) { (result, err) in
                    if result?.isCancelled == false{
                    let request = GraphRequest(graphPath: "me", parameters:  ["fields": "id, email, name, first_name, last_name, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: .none, httpMethod: .get)
                    self.showActivity()
                    request.start { (response, result, err) in
                        self.hideActivity()
                        if err == nil{
                            let resultDict = result as? [String:Any] ?? [:]
                            print(resultDict)
                            self.mainSocailKey = resultDict["id"] as? String
                            RegisterViewController.displayName = resultDict["name"] as? String
                            UserStoreSingleton.shared.email = resultDict["email"] as? String
                            UserStoreSingleton.shared.name = resultDict["first_name"] as? String
                            UserStoreSingleton.shared.lastname = resultDict["last_name"] as? String
                            let dataDict = resultDict["picture"] as? [String:Any] ?? [:]
                            let imageDict = dataDict["data"] as? [String:Any] ?? [:]
                            UserStoreSingleton.shared.socailProfileImage = imageDict["url"] as? String 
                            self.socialSignInAPI()
                        }else{
                            self.showMessage(err?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
    
    
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
    
    @IBAction func didTappedGoogleSignInButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
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
    
    private func userLogin() {
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
    
    
    func socialSignInAPI() {
        self.showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/social-signIn") else { return }
        let request = NSMutableURLRequest(url: gitUrl)
        let parameters = ["socialKey": mainSocailKey,"signUpType":"1"]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        self.hideActivity()
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
                        if gitData.data?.user_verified == 0{
                            self.sendOtp()
                            self.navigate(.twosetpVerification)
                        }
                    
                        else {
                            self.showMessage(gitData.message ?? "")
                            UserStoreSingleton.shared.phoneNumer = phoneNumber
                            UserStoreSingleton.shared.userToken = gitData.data?.token
                            RootRouter().loadMainHomeStructure()
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
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["feilds": "email,name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
            print("\(String(describing: result))")
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
    
}


extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.hideActivity()
            print(error)
            return
        }
        
//        guard let user = signIn.Authentication else {
//            self.hideActivity()
//
//        }
        
        if let optionalCurrentUser = GIDSignIn.sharedInstance().currentUser {
            let gmailUserImageUrl = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 120)?.absoluteString
            guard let socailKey = optionalCurrentUser.userID else {return}
            mainSocailKey = socailKey
            guard let gmailUsername = optionalCurrentUser.profile.name else {return}
            let firstName = gmailUsername.byWords.first
            let lastName = gmailUsername.byWords.last
            guard let email = optionalCurrentUser.profile.email else {return}
            UserStoreSingleton.shared.email = email
            UserStoreSingleton.shared.profileImage = gmailUserImageUrl
            let separated = gmailUsername.split(separator: " ").map { String($0) }
                if let firstName = separated.first {
                    let firstValue = String(firstName)
                    UserStoreSingleton.shared.name = firstValue
                    LoginViewController.googleLoginName = firstName
                }
            if let lastName = separated.last {
                let lastValue = String(lastName)
                UserStoreSingleton.shared.lastname = lastValue
                LoginViewController.googleLoginLastName = lastValue
            }
            self.socialSignInAPI()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Dissconnect")
    }
    
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//            self.dismiss(animated: true, completion: nil)
//        }
    
}

extension StringProtocol {
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}
