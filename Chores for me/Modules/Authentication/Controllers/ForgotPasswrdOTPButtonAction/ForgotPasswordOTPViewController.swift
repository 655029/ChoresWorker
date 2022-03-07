//
//  ForgotPasswordOTPViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit

class ForgotPasswordOTPViewController: BaseViewController, UITextFieldDelegate {


    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstOtpTextFeild: UITextField!
    @IBOutlet weak var secondOtpTextfeild: UITextField!
    @IBOutlet weak var thirdOtpTextfeild: UITextField!
    @IBOutlet weak var fourthOtpTextFeild: UITextField!
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    
    // MARK: - Properties
    var otpFeild: Int?
    var otpTimer = Timer()
    var totalTime = 31

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.navigationBar.isHidden = true
        let image = UIImage(named: "BACK")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = .white
        firstOtpTextFeild.delegate = self
        secondOtpTextfeild.delegate = self
        thirdOtpTextfeild.delegate = self
        fourthOtpTextFeild.delegate = self
        
        firstOtpTextFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        secondOtpTextfeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        thirdOtpTextfeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fourthOtpTextFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        resendButton.setTitle("Click in ", for: .normal)
       otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

    }
   

    @objc func textFieldDidChange(textField: UITextField){

        let text = textField.text

        if (text?.utf16.count)! >= 1{
            switch textField{
            case firstOtpTextFeild:
                secondOtpTextfeild.becomeFirstResponder()
            case secondOtpTextfeild:
                thirdOtpTextfeild.becomeFirstResponder()
            case thirdOtpTextfeild:
                fourthOtpTextFeild.becomeFirstResponder()
            case fourthOtpTextFeild:
                fourthOtpTextFeild.resignFirstResponder()
            default:
                break
            }
        }else{

        }

        if  text?.count == 0 {
                    switch textField{
                    case firstOtpTextFeild:
                        firstOtpTextFeild.becomeFirstResponder()
                    case secondOtpTextfeild:
                        firstOtpTextFeild.becomeFirstResponder()
                    case thirdOtpTextfeild:
                        secondOtpTextfeild.becomeFirstResponder()
                    case fourthOtpTextFeild:
                        thirdOtpTextfeild.becomeFirstResponder()
                    default:
                        break
                    }
                }
                else{

                }
    }

  

    // MARK: - Layout

    // MARK: - User Interaction
    @IBAction func verifyButtonAction(_ sender: Any) {
//        navigate(.resetPassword)
        if let firstTextfeildText = firstOtpTextFeild.text, let secondTextFeildText = secondOtpTextfeild.text, let thirdTextFeildText = thirdOtpTextfeild.text, let fourthTextFeildText = fourthOtpTextFeild.text {
            if firstTextfeildText == ""   {
                openAlert(title: "Chores for me", message: "Invalid OTP", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else if secondTextFeildText == "" {
                openAlert(title: "Chores for me", message: "Invalid OTP", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            
            else if thirdTextFeildText == "" {
                openAlert(title: "Chores for me", message: "Invalid OTP", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else if fourthTextFeildText == "" {
                openAlert(title: "Chores for me", message: "Invalid OTP", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                }])
            }
            else {
                if Reachability.isConnectedToNetwork(){
                   resetOtpVerification()
                }else{
                    openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                        
                    }])
                }
            }
        }
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func resendOtpBtn(_ sender: Any) {
        totalTime = 31
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: - Additional Helpers
    @objc func updateTimer() {
        if totalTime > 0 {
            totalTime = totalTime - 1
            //print(totalTime)
            countDownLabel.isHidden = false
            countDownLabel.text = String(totalTime)
            resendButton.setTitle("Click in", for: .normal)
            resendButton.isEnabled = false
        }
        else {
            countDownLabel.isHidden = true
            resendButton.setTitle("Click Here", for: .normal)
            resendButton.isEnabled = true
            otpTimer.invalidate()
        }

    }
    func resetOtpVerification() {
        showActivity()
        let Url = String(format: "http://3.18.59.239:3000/api/v1//reset-otp-verification")
        guard let serviceUrl = URL(string: Url) else { return }
        let otpTextField = "\(firstOtpTextFeild.text ?? "")\(secondOtpTextfeild.text ?? "")\(thirdOtpTextfeild.text ?? "")\(fourthOtpTextFeild.text ?? "")"
        let parameterDictionary =  ["email": UserStoreSingleton.shared.email ?? "","OTP": otpTextField] as [String: Any]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(VerifyOtpModel.self, from: data)
                //print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let status = gitData.status
                    self.showMessage(gitData.message ?? "")
                    if status == 200{
                        self.navigate(.resetPassword)
                    } else {
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                self.hideActivity()
                print("Err", err)
            }
        }.resume()
    }
    
}


