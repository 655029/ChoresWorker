//
//  RegisterViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import ADCountryPicker
import Alamofire
import GoogleSignIn
import FirebaseAuth
import Designable
import FBSDKLoginKit
import FBSDKCoreKit

class RegisterViewController: UIViewController,ADCountryPickerDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfeild: UITextField!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var countryCodeTextFeild: UITextField!
    @IBOutlet weak var lastNameField: AppTextField!
    @IBOutlet weak private var showPasswordBtnIcon: UIButton!
    @IBOutlet weak private var showConfirmPasswordBtnIcon: UIButton!
    @IBOutlet weak var facebookLoginButton: DesignableButton!
    
    
    // MARK: - Properties
    var imagePicker = UIImagePickerController()
    let picker = ADCountryPicker()
    var photoURL : URL!
    var imageForm: Data?
    var imageResponse = String()
    static var signInEmail : String?
    static var socialKey : String?
    var nameKey: String?
    var phoneNumberKey : String?
    static var displayName: String?
    var showPasswordIcon: Bool = true
    var showConfirmPasswordIcon: Bool = true
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyFinishingTouchesToUIElements()
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
                            RegisterViewController.socialKey = resultDict["id"] as? String
                            RegisterViewController.displayName = resultDict["name"] as? String
                            RegisterViewController.signInEmail = resultDict["email"] as? String
                            UserStoreSingleton.shared.name = resultDict["first_name"] as? String
                            UserStoreSingleton.shared.lastname = resultDict["last_name"] as? String
                            self.navigate(.facebookLogin)
                        }else{
                            self.showMessage(err?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
    
    @IBAction func googleButton(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text, let phoneNumber = phoneNumberTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextfeild.text, let imageSystem =  UIImage(named: "upload profile picture") {
            if uploadImageView.image?.pngData() == imageSystem.pngData()  {
                openAlert(title: "Chores for me", message: "Please Upload Profile Image", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                }])
            }
            else if name == "" {
                openAlert(title: "Chores for me", message: "Please Enter Name", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    
                }])
            }
            else if email == "" {
                openAlert(title: "Chores for me", message: "Please Fill Email", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    
                }])
            }
            else if !email.isValidEmail {
                openAlert(title: "Chores for me", message: "Invalid Email Address", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else if phoneNumber == "" {
                openAlert(title: "Chores for me", message: "Please Enter Mobile Number", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            
            else if !phoneNumber.isPhoneNumber {
                openAlert(title: "Chores for me", message: "Invalid Mobile Number", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else if password == "" {
                openAlert(title: "Chores for me", message: "Please Enter  Paswword", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            
            else if !password.isPasswordValid {
                openAlert(title: "Chores for me", message: "Invalid Password Should contain 7 Characters, including UPPER/lowercase and numbers", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else if confirmPassword == "" {
                openAlert(title: "Chores for me", message: "Please Enter  confirmPassword", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else if confirmPassword != password {
                openAlert(title: "Chores for me", message: " Password and Confirm Password Are Not Equal", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else {
                if Reachability.isConnectedToNetwork(){
                    RegisterApi()
                }else{
                    openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    }])
                }
            }
        }
    }
    
    @IBAction func uploadProfilePicture(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
        }
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func backToLoginButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTappedImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTappedCountryCodeTextFeild(_ sender: UITapGestureRecognizer) {
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedShowPasswordIcon(_ sender: UIButton) {
        showPasswordBtnIcon.isSelected.toggle()
        if(showPasswordIcon == true) {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        
        showPasswordIcon = !showPasswordIcon
    }
    
    @IBAction func didtappedShowConfirmPasswordIcon(_ sender: UIButton) {
        showConfirmPasswordBtnIcon.isSelected.toggle()
        if(showConfirmPasswordIcon == true) {
            confirmPasswordTextfeild.isSecureTextEntry = false
        } else {
            confirmPasswordTextfeild.isSecureTextEntry = true
        }
        
        showConfirmPasswordIcon = !showConfirmPasswordIcon
    }
    
    
    // MARK: - CountryPicker View Delegate
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        countryCodeTextFeild.text = dialCode
        UserStoreSingleton.shared.Dialcode = dialCode
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Additional Helpers
    private func applyFinishingTouchesToUIElements() {
        self.facebookLogin()
        self.googleLogin()
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        lastNameField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextfeild.delegate = self
        imagePicker.delegate = self
        facebookLoginButton.addTarget(self, action: #selector(didTappedFacebookButton(_:)), for: .touchUpInside)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.pickerTitle = "Select a Country"
        picker.defaultCountryCode = "US"
        picker.forceDefaultCountryCode = true
        navigationController?.navigationBar.isHidden = true
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.tintColor = AppColor.primaryBackgroundColor
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
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - UIImagePickerDelegate Methods
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        uploadImageView.image = info[.originalImage] as? UIImage
    //        imagePicker.dismiss(animated: true, completion: nil)
    //    }
    func RegisterApi() {
        showActivity()
        let Url = String(format: "http://3.18.59.239:3000/api/v1/signup")
        guard let serviceUrl = URL(string: Url) else { return }
        
        let parameterDictionary =  ["email":emailTextField.text ?? "","first_name":nameTextField.text ?? "","last_name": lastNameField.text ?? "","password":passwordTextField.text ?? "", "phone":"\(UserStoreSingleton.shared.Dialcode ?? "")\(phoneNumberTextField.text ?? "")" ,"signupType":"1","otp":"","location_address":"","image":imageResponse] as [String: Any]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(RegisterModel.self, from: data)
                    // print(json)
                    
                    DispatchQueue.main.async { [self] in
                        self.hideActivity()
                        let responseMessage = json.status
                        if responseMessage == 200 {
                            UserStoreSingleton.shared.email = self.emailTextField.text
                            UserStoreSingleton.shared.phoneNumer = self.phoneNumberTextField.text
                            UserStoreSingleton.shared.pass = self.passwordTextField.text
                            UserStoreSingleton.shared.name = self.nameTextField.text
                            UserStoreSingleton.shared.lastname = self.lastNameField.text
                            sendOtp()
                        } else {
                            showMessage(json.message ?? "")
                        }
                    }
                } catch {
                    self.hideActivity()
                    print(error)
                    self.showMessage("Error")
                    //  self.hideActivity()
                }
            }
        }.resume()
    }
    
    func sendOtp() {
        //showActivity()
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
                        self.navigate(.twosetpVerification)
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
    
    func updateProfile() {
        showActivity()
        let image = uploadImageView.image
        let imgData = image!.jpegData(compressionQuality: 0.2)!
        print(imgData)
        
        let parameters = ["":"" ] //Optional for extra parameter
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"http://3.18.59.239:3000/api/v1/upload")
        { (result) in
            switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        // debugPrint("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        // debugPrint(response.result.value as Any)
                        if let data = response.data {
                            self.hideActivity()
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    // try to read out a dictionary
                                    print(json)
                                    if let data = json["data"] as? String {
                                        print(data)
                                        self.imageResponse = data
                                    }
                                }
                            } catch let error as NSError {
                                self.hideActivity()
                                print("Failed to load: \(error.localizedDescription)")
                            }
                        }
                    }
                    //   self.hideActivity()
                    
                case .failure(let encodingError):
                    debugPrint(encodingError)
            }
        }
    }
    
    func socialSignUpAPI(){
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/social-signUp") else { return }
        let request = NSMutableURLRequest(url: gitUrl)
        let parameters = ["name":RegisterViewController.displayName,
                          "email": RegisterViewController.signInEmail,
                          "image":"",
                          "phone": phoneNumberKey,"socialKey":RegisterViewController.socialKey,"signupType":"1"]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(SocialSignUpModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let responseMessage = gitData.status;
                    if responseMessage == 200 {
                        self.showMessage(gitData.message ?? "")
                        UserStoreSingleton.shared.Token = gitData.data?.token
                        self.navigate(.login)
                    }else{
                        self.showMessage(gitData.message ?? "")
                        
                    }
                }
                
            } catch let err {
                self.hideActivity()
                //self.showMessage("error occured")
                print("Err", err)
            }
        }.resume()
    }
}


extension String {
    
    var isPasswordValid: Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{7,}$")
        return passwordTest.evaluate(with: self)
    }
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
}


extension RegisterViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        if(picker.sourceType == .photoLibrary)
        {
            if let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            {
                let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                uploadImageView.image = pickedImage
                print(pickedImage as Any)
                // imageForm = pickedImage
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                let data = image.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                photoURL = URL.init(fileURLWithPath: localPath)
                print(photoURL!)
                picker.dismiss(animated: true, completion: nil)
                updateProfile()
            }
        }
        else
        {
            let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            uploadImageView.image = pickedImage
            print(pickedImage as Any)
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            let data = pickedImage!.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            photoURL = URL.init(fileURLWithPath: localPath)
            print(photoURL!)
            updateProfile()
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}



// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case nameTextField:
                emailTextField.becomeFirstResponder()
            case emailTextField:
                phoneNumberTextField.becomeFirstResponder()
            case phoneNumberTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                confirmPasswordTextfeild.becomeFirstResponder()
            case confirmPasswordTextfeild:
                // Register action
                break
            default:
                textField.resignFirstResponder()
        }
        
        return true
    }
}

extension RegisterViewController: LoginButtonDelegate {
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


extension RegisterViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.hideActivity()
            print(error)
            return
        }
        let gmailUserImageUrl = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 120)?.absoluteString
        if let optionalCurrentUser = GIDSignIn.sharedInstance().currentUser {
            guard let socailKey = optionalCurrentUser.userID else {return}
            RegisterViewController.socialKey = socailKey
            guard let gmailUsername = optionalCurrentUser.profile.name else {return}
            guard let userGmail = optionalCurrentUser.profile.email else {return}
            RegisterViewController.displayName = gmailUsername
            RegisterViewController.signInEmail = userGmail
//            self.socialSignUpAPI()
            self.navigate(.googleLogin)
            
            
        }
        
    }
    
    public func sign(_ signIn: GIDSignIn!,
                     dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
}

