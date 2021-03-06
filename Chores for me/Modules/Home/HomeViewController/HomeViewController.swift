//
//  HomeViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit
import Designable
import SDWebImage
import CoreLocation


class HomeViewController: HomeBaseViewController, UITableViewDelegate, CLLocationManagerDelegate, UITableViewDataSource {
    
    
    // MARK: - Outlets
    @IBOutlet var view_OopsView: UIView!
    @IBOutlet weak var currentLocationButton: DesignableButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var getReqProviderData  = [GetReqOnProviderSideModelData]()
    var lat : Double?
    var long: Double?
    var latitude: String?
    var longitude: String?
    var locationManager = CLLocationManager()
    var location_Manager = CLLocationManager()
    var location_Name : String?
    var jobId = Int()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            print("Location Enabled")
            locationManager.startUpdatingLocation()
        }
        else {
            print("Location not enabled")
        }
        NotificationCenter.default.addObserver(self, selector:#selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "Forground"), object: nil)
        NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        currentLocationButton.addSpaceBetweenImageAndTitle(spacing: 10)
        getUserProfile()
        if Reachability.isConnectedToNetwork(){
            GetReqOnProviderSide()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                
            }])
        }
    }
    
    @objc func handleNotification(n : NSNotification) {
        print(n)
        let dicData = n.object as! [String: String]
        let notificationType = dicData["notificationType"]!
        if notificationType == "request" {
            let screenShotImage = TakeScreenShotImage.shareInstance.takeScreenshot(false) ?? UIImage()
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            let secondVc = storyboard.instantiateViewController(withIdentifier: "NewBookingViewController") as! NewBookingViewController
            secondVc.delegate = self
            secondVc.sSImage = screenShotImage
            self.present(secondVc, animated: false, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.currentLocationButton.setTitle(UserStoreSingleton.shared.locationName, for: .normal)
        navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "")"
        if Reachability.isConnectedToNetwork(){
            GetReqOnProviderSide()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                
            }])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    // MARK: - Additional Helpers
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigate(.jobStatus(jobId: getReqProviderData[indexPath.row].jobId ?? 0))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getReqProviderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell else {
            return UITableViewCell()
        }
        if getReqProviderData.count > 0 {
            cell.priceLabel.text = getReqProviderData[indexPath.row].price
            let selectedDay = getReqProviderData[indexPath.row].day
            let day = String(selectedDay!.dropFirst(1))
            let space = day.trimmingCharacters(in: .whitespacesAndNewlines)
           // let day1 = String(selectedDay?.dropFirst())
            //            selectedDay = selectedDay!.replacingOccurrences(of: " \n", with: "", options: NSString.CompareOptions.literal, range: nil)
            //            let dayWithOutDate = String((selectedDay?.dropFirst(3))!)
            cell.dateLabel1.text = getReqProviderData[indexPath.row].day
            cell.nameLabel1.text = self.getReqProviderData[indexPath.row].userDetails?.first_name
            cell.locationLabel1.text = getReqProviderData[indexPath.row].location
            cell.time40Label.text = getReqProviderData[indexPath.row].totalTime
            cell.serviceImageView1.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageUrl = URL(string: getReqProviderData[indexPath.row].image ?? "")
            cell.serviceImageView1?.sd_setImage(with: imageUrl) { (image, error, cache, urls) in
                if (error != nil) {
                    cell.serviceImageView1.image = UIImage(named: "outdoor_home_service")
                } else {
                    cell.serviceImageView1.image = image
                }
            }
            cell.nameLabel1.text = self.getReqProviderData[indexPath.row].userDetails?.first_name
            cell.profileImageView1.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let profileUrl = URL(string: "\(getReqProviderData[indexPath.row].userDetails?.image ?? "")")
            cell.profileImageView1?.sd_setImage(with: profileUrl) { (image, error, cache, urls) in
                if (error != nil) {
                    cell.profileImageView1.image = UIImage(named: "user.profile.icon")
                } else {
                    cell.profileImageView1.image = image
                }
            }
            let arrayData = getReqProviderData[indexPath.row].subcategoryId
            cell.homeArrSubCategory = arrayData ?? []
            let date = getDate(date: getReqProviderData[indexPath.row].booking_date ?? "")
            let time = getReqProviderData[indexPath.row].time ?? ""
            let dateTime = time + " : " + date!
            cell.lbl_createTime.text = dateTime
            UserStoreSingleton.shared.jobId = getReqProviderData[indexPath.row].jobId
            
            cell.view_Rating.rating = Double((getReqProviderData[indexPath.row].userDetails?.rating ?? 0.0) as Float)
            cell.copybtn.addTarget(self, action: #selector(copy_btn_Tapped(_:)), for: .touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func copy_btn_Tapped(_ sender: UIButton){
        let location = getReqProviderData[sender.tag].location
        UIPasteboard.general.string = location
        showMessage("Text Copied")
    }
    func GetReqOnProviderSide(){
        showActivity()
        self.getReqProviderData.removeAll()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-Requests-On-providerSide")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetReqOnProviderSideModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.getReqProviderData = json.data ?? []
                  //  print("Data===", json.data!)
                    if self.getReqProviderData.count == 0{
                        // self.showMessage(json.message ?? "")
                        self.view_OopsView.isHidden = false
                    }else{
                        self.view_OopsView.isHidden = true
                        self.getReqProviderData.reverse()
                    }
                    self.tableView.reloadData()
                }
            } catch {
                self.hideActivity()
                print(error)
            }
        }
        task.resume()
    }
    func getUserProfile() {
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetUserProfileModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.currentLocationButton.setTitle("\(json.data?.location_address ?? "")", for: .normal)
                    if json.data?.first_name != nil {
                        UserStoreSingleton.shared.name = json.data?.first_name
                    }

                    self.navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "")"
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get current location
        let userLocation = locations[0] as CLLocation
        
        //get latitude, longitude
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        print("latitude of current location\(latitude)")
        print("latitude of current location\(longitude)")
        UserStoreSingleton.shared.currentLat = latitude
        UserStoreSingleton.shared.currentLong = longitude
        
        // get address
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error == nil {
                print("Error in geoCoderLocation")
            }
            //            let placemark = placemarks! as [CLPlacemark] // sometime yha crash hota hai....
            guard let placemark = placemarks else {return}
            if (placemark.count > 0) {
                let placemark = placemarks![0]
                let locality = placemark.locality ?? ""
                let adminstartiveArea = placemark.subAdministrativeArea ?? ""
                let country = placemark.country ?? ""
                print("current addres:---- \(adminstartiveArea), \(locality), \(country)")
                UserStoreSingleton.shared.Address = ("\(adminstartiveArea), \(locality), \(country)")
                BookingsViewController.locationForBooking = "\(adminstartiveArea), \(locality), \(country)"
                BookingHistoryViewController.locationForBookingHistory = "\(adminstartiveArea), \(locality), \(country)"
                self.currentLocationButton.setTitle(UserStoreSingleton.shared.Address, for: .normal)
                
            }
            
        }
        
    }
    
}

extension HomeViewController : fromNotification {
    func dissmissNotification(jobId: Int) {
        print("------Working-----")
        self.navigate(.jobStatus(jobId: jobId))
    }
}

