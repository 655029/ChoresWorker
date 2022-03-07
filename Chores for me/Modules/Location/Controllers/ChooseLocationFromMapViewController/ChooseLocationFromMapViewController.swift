//
//  ChooseLocationFromMapViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 15/04/21.


import UIKit
import SnapKit
import GoogleMaps
import SwiftyJSON

class ChooseLocationFromMapViewController: UIViewController, GMSMapViewDelegate {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var address : String?
    var currentLocation:CLLocationCoordinate2D!
    var locationMarker:GMSMarker!
    var geoCoder :CLGeocoder!
    lazy var button : UIButton = {
        let  mbutton = UIButton()
        mbutton.translatesAutoresizingMaskIntoConstraints = false
        mbutton.setImage(UIImage(named: "nextBtn"), for: .normal)
        return mbutton
    }()
    lazy var markerImage : UIImageView = {
        let imge =  UIImageView()
        imge.image = UIImage(named: "mpin")
        imge.translatesAutoresizingMaskIntoConstraints = false
        return imge
    }()
    lazy var searchTextField : UITextField = {
       let text = UITextField()
        text.clearButtonMode = .always
        return text
    }()
    
    var mapView: GMSMapView!
    let zoom: Float = 12
    let marker = GMSMarker()
    let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
        addButton()
        addSearchText()
        addMarkerImage()
        button.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
        geoCoder = CLGeocoder()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        mapView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mapView.delegate = self
        //  mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 50)
    }
    
    @objc func btnClicked(sender:UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    func addButton(){
        mapView.addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        let centerXConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 140)
        let centerYConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -220)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        
    }
    // MARK: - Layout
    
    private func addSearchText() {
        searchTextField.frame = CGRect(x: 0, y: -2, width: 300, height: 35)
        searchTextField.placeholder = " Search..."
       // searchTextField.isUserInteractionEnabled = false
        searchTextField.font = AppFont.font(style: .regular, size: 15)
        searchTextField.textColor = UIColor.black
        searchTextField.backgroundColor = UIColor.white
        self.navigationItem.titleView = searchTextField
    }
    private func addMapView() {
        mapView = GMSMapView()
        view.backgroundColor = UIColor.clear
        view.addSubview(mapView)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    func addMarkerImage(){
        mapView.addSubview(markerImage)
        let centerXConstraint = NSLayoutConstraint(item: markerImage, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: markerImage, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1.0, constant: -27)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }
}
        // MARK: - User Interaction
        
        
        // MARK: - Additional Helpers
    

// MARK: - UISearchResultsUpdating


extension ChooseLocationFromMapViewController: CLLocationManagerDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let lat = position.target.latitude
        UserStoreSingleton.shared.userlat = lat
        let lng = position.target.longitude
        UserStoreSingleton.shared.userLong = lng
        let location = CLLocation(latitude: lat, longitude: lng)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks{
                if (placemarks.first?.location) != nil{
                    if let addressDict = (placemarks.first?.addressDictionary as NSDictionary?){
                        let dict = JSON(addressDict)
                        var address:String = ""
                        for data in dict["FormattedAddressLines"].arrayValue{
                            address = address+" "+data.stringValue
                            // print("address----\(address)")
                            self.locationManager.startUpdatingLocation()
                            self.searchTextField.text = address
                            UserStoreSingleton.shared.Address = address
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15)
        self.mapView?.animate(to: camera)
        self.locationManager.delegate = nil
    }
    
}

