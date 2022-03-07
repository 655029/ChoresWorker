//
//  ChooseYourCityViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Designable
import DropDown



var TestComeFrom = "MapScreen"
class ChooseYourCityViewController: ServiceBaseViewController {
    

    // MARK: - Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var radiousTextField: UITextField!
    @IBOutlet weak var nextButtonBottomCostraint: NSLayoutConstraint!
    @IBOutlet weak var meterButton: UIButton!
    
    // MARK: - Properties
    private var initialBotoomDistance: CGFloat = 0
    let transparentView = UIView()
    let tableView = UITableView()
    let dropDown = DropDown()
    var dataSource = [String]()
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserStoreSingleton.shared.pass != nil {
            userLogin()
        }
        stepLabel.text = "1/5"
        locationTextField.delegate = self
        navigationItem.title = AppString.CHOOSE_YOUR_CITY
        subscribeToShowKeyboardNotifications()
        initialBotoomDistance = nextButtonBottomCostraint.constant
        navigationController?.darkNavigationBar()
        locationTextField.isEnabled = false
        meterButton.layer.cornerRadius = 5.0
        tabBarController?.tabBar.isHidden = true
        locationTextField.text = UserStoreSingleton.shared.Address
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.navigationBar.isHidden = false
            locationTextField.text = UserStoreSingleton.shared.Address
            stepLabel.text = "1/5"
            navigationItem.title = AppString.CHOOSE_YOUR_CITY
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
    
    // MARK: - User Interaction
    
    @IBAction func selctOnMapButtonAction(_ sender: Any) {
        navigate(.chooseLocationOnMap)
    }
    @IBAction func nextButoonAction(_ sender: Any) {
        if locationTextField.text?.isEmpty == true {
            openAlert(title: "Chores for me", message: "Please Select Location", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        }else if  radiousTextField.text?.isEmpty == true{
            openAlert(title: "Chores for me", message: "Please Select Radius", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
            
        } else {
            if Reachability.isConnectedToNetwork(){
                updateProviderLocation()
                
            }else{
                openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    
                }])
            }
           
        }
    }
    
    @IBAction func dropDownButtonAction(_ sender: DesignableButton) {
        dropDown.show()
        dropDown.anchorView = meterButton
        dropDown.dataSource = ["Meter", "KiloMeter", "Miles"]
        dropDown.direction = .any
        dropDown.width = 150
        dropDown.direction = .bottom
        dropDown.topOffset = CGPoint(x: 0, y: 200)
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            meterButton.setTitle(item, for: .normal)
            
        }
    }
    
    // MARK: - Additional Helpers
    
    func userLogin() {
        //start loader here
       // showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/login") else { return }
        //print(gitUrl)
        
        let request = NSMutableURLRequest(url: gitUrl)
        let parameters = [
            "email" :UserStoreSingleton.shared.email ?? "",
            "password": UserStoreSingleton.shared.pass!,
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
                        let headersvalue = gitData.data?.token
                        UserStoreSingleton.shared.Token = headersvalue
                        self.getUserProfile()
                    }else{
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
       // showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetUserProfileModel.self, from: data ?? Data())
                //debugPrint(json)
                // print(GetUserProfile.self)
                DispatchQueue.main.async {
                   // self.hideActivity()
                    UserStoreSingleton.shared.name = json.data?.first_name
                    UserStoreSingleton.shared.profileImage = json.data?.image
                    UserStoreSingleton.shared.userID = json.data?.userId
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }    
    private func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if nextButtonBottomCostraint.constant != initialBotoomDistance {
            self.view.layoutIfNeeded() // call
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.nextButtonBottomCostraint.constant = self.initialBotoomDistance
                self.view.layoutIfNeeded() // call
            }
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.height
            self.view.layoutIfNeeded() // call
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.nextButtonBottomCostraint.constant = height
                self.view.layoutIfNeeded() // call
            }
        }
    }
    
    @objc func removeTransparentView() {
        let frames = meterButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }

    //    http://3.18.59.239:3000/api/v1/update-provider-location
    func updateProviderLocation(){
        showActivity()
        let parameters = ["UserId" :"\(UserStoreSingleton.shared.userID ?? 0)",
                          "lat": UserStoreSingleton.shared.userlat ?? 0,
                          "lng":UserStoreSingleton.shared.userLong ?? 0,
                          "location_address":UserStoreSingleton.shared.Address ?? 0] as [String : Any]
        let url = URL(string: "http://3.18.59.239:3000/api/v1/update-provider-location")
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
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(UpdateUserProfile.self, from: data)
                DispatchQueue.main.async {
                    self.hideActivity()
                    if gitData.status == 200{
                        self.navigate(.chooseService)
                        self.showMessage(gitData.message ?? "")
                    } else{
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch  {
                self.hideActivity()
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}

// MARK: - UITextFieldDelegate

extension ChooseYourCityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case locationTextField:
            radiousTextField.becomeFirstResponder()
        case radiousTextField: break
        // Implemet navigation action
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}
