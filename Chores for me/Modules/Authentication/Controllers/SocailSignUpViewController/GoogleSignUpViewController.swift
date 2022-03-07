//
//  GoogleSignUpViewController.swift
//  Chores for me
//
//  Created by Ios Mac on 22/02/22.
//

import UIKit
import ADCountryPicker

class GoogleSignUpViewController: BaseViewController, ADCountryPickerDelegate {
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var gmailUserName: UILabel!
    @IBOutlet weak private var mobileNumberLabel: UILabel!
    @IBOutlet weak private var mobileNumberTextFeild: UITextField!
    @IBOutlet weak private var checkBoxButton: UIButton!

    
    //MARK: - Properties
    private var picker = ADCountryPicker()

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyFinishingTouchesToUIElements()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        gmailUserName.text = RegisterViewController.displayName
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.pickerTitle = "Select a Country"
        picker.defaultCountryCode = "US"
        picker.forceDefaultCountryCode = true
        picker.font = UIFont(name: "Helvetica Neue", size: 18)
    }
    
    
    private func callingSignUpAPI() {
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/social-signUp") else { return }
        let request = NSMutableURLRequest(url: gitUrl)
        let phoneNumber = "\(UserStoreSingleton.shared.Dialcode ?? "")\(mobileNumberTextFeild.text ?? "")"
        let parameters = ["name":RegisterViewController.displayName!,
                          "email": RegisterViewController.signInEmail!,
                          "image":UserStoreSingleton.shared.socailProfileImage!,
                          "phone": phoneNumber,"socialKey":RegisterViewController.socialKey!,"signupType":"1"] as [String : Any]
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
//                        self.navigate(.login)
                        self.sendOtp()
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
    
    
    private func sendOtp() {
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
    
    
    //MARK: - Ineterface Builder Actions
    @IBAction func didTappedSignUpButton(_ sender: UIButton) {
        if let name = gmailUserName.text, let mobile = mobileNumberTextFeild.text, let image =  UIImage(named: "Unchecked-Checkbox-256") {
            if name == "" {
                openAlert(title: "Alert", message: "Name can't be empty.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

           else if mobile == "" {
               openAlert(title: "Alert", message: "Please Enter Mobile Number", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            
           else if checkBoxButton.imageView?.image?.pngData() == image.pngData() {
               openAlert(title: "Alert", message: "Please Select Chores For Me Terms and Conditions", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
           }
            
            else {
                UserStoreSingleton.shared.socailphoneNumber = mobileNumberTextFeild.text
                UserStoreSingleton.shared.phoneNumer = mobileNumberTextFeild.text
                self.callingSignUpAPI()
            }
        }
        
    }

    @IBAction func didTappedSignInButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let secondSc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.pushViewController(secondSc, animated: true)
        
    }
    
    @IBAction func didTappedCheckBoxButton(_ sender: UIButton) {
        checkBoxButton.isSelected.toggle()
    }
    
    @IBAction func didTappedShowCountriesButton(_ sender: UIButton) {
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        mobileNumberLabel.text = dialCode
        UserStoreSingleton.shared.Dialcode = dialCode
        picker.font = UIFont(name: "Medium", size: 22.0)
        self.dismiss(animated: true, completion: nil)
    }
    
}
