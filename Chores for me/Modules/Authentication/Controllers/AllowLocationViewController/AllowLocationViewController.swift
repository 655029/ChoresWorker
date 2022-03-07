//
//  AllowLocationViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 03/08/21.
//

import UIKit
import CoreLocation

class AllowLocationViewController: UIViewController , CLLocationManagerDelegate {
    var location_manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        if TestComeFrom == "MapScreen"{
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.backgroundColor = .white
        }else{
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.backgroundColor = .white
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if TestComeFrom == "MapScreen"{
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.backgroundColor = .white
        }else{
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.backgroundColor = .white
        }
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func btn_back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allowButtonAction(_ sender: UIButton) {
        let locatePermission = LocationPermission.CheckLocationPermision(.init())
        if !locatePermission() {
            location_manager.delegate = self
            location_manager.requestLocation()
            location_manager.requestWhenInUseAuthorization()
            location_manager.requestAlwaysAuthorization()
        }
        else {
//            userLogin()
            self.navigate(.chooseYourCity)
        }
        UserStoreSingleton.shared.isLocationEnbled = locatePermission()
    }
   
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("-----\(error)------")
        hideActivity()
        showPermissionAlert()
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .denied || status == .notDetermined || status == .restricted {
            hideActivity()
            self.showPermissionAlert() 
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        hideActivity()
        if locations.first != nil {
            UserStoreSingleton.shared.isLocationEnbled = true
            print("location:: (location)")
            userLogin()
            location_manager.stopUpdatingLocation()
            location_manager.delegate = nil
        }
    }
    func userLogin() {
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/login") else { return }
       
        let request = NSMutableURLRequest(url: gitUrl)
        
        let parameters = [
            "email" : UserStoreSingleton.shared.email ?? "",
            "password": UserStoreSingleton.shared.pass ?? "",
            "signupType":"1",
            "deviceID":UserStoreSingleton.shared.fcmToken ??  "",
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
                    if gitData.data?.docStatus == "" {
                        self.navigate(.chooseYourCity)
                    }
                    else{
                        if gitData.data?.docStatus != nil && gitData.data?.user_verified != 0 {
                            RootRouter().loadMainHomeStructure()
                        }
                        else {
                            self.navigate(.chooseYourCity)
                        }
                    }
                }
            } catch let err {
              //  self.hideActivity()
                self.showMessage("error occured")
                print("Err", err)
            }
        }.resume()
    }


}




    
