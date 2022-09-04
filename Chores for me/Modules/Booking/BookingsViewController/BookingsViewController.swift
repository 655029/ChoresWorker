//
//  BookingsViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit
import Designable
import SDWebImage

class BookingsViewController: HomeBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var locationButton: DesignableButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var view_OopsViewBooking: UIView!
    // MARK: - Properties
    var getProviderBookingData  = [GetReqOnProviderSideModelData]()
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "")"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BookingsTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        locationButton.addSpaceBetweenImageAndTitle(spacing: 10.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
       // self.locationButton.setTitle(UserStoreSingleton.shared.locationName, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork(){
            bookings()
            
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                
            }])
        }
        tabBarController?.tabBar.isHidden = false
        self.locationButton.setTitle(UserStoreSingleton.shared.locationName, for: .normal)
    }
    
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    
    
    // MARK: - Additional Helpers
    func bookings(){
        showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-provider-bookings")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetReqOnProviderSideModel.self, from: data ?? Data())
                // debugPrint(json)
                DispatchQueue.main.async {
                    self.hideActivity()
                    
                    self.getProviderBookingData.removeAll()
                    self.getProviderBookingData = json.data!
                    if self.getProviderBookingData.count == 0{
                      //  self.showMessage(json.message ?? "")
                        self.view_OopsViewBooking.isHidden = false
                        self.tableView.isHidden = true
                        
                    }else{
                        self.view_OopsViewBooking.isHidden = true
                        self.tableView.isHidden = false
                        //self.getProviderBookingData = json.data!
                        
                    }
                    self.tableView.reloadData()
//                    else{
//                        self.showMessage(json.message ?? "")
//                    }
                }
            } catch {
                self.hideActivity()
                print(error)
            }
        }
        task.resume()
    }
}

// MARK: - UITableViewDelegate

extension BookingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigate(.jobStatus(jobId: getProviderBookingData[indexPath.row].jobId ?? 0))
    }
    
}

// MARK: - UITableViewDataSource

extension BookingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getProviderBookingData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTableViewCell") as? BookingsTableViewCell else {
            return UITableViewCell()
        }
        var selectedDay = getProviderBookingData[indexPath.row].day
        selectedDay = selectedDay!.replacingOccurrences(of: " \n", with: "", options: NSString.CompareOptions.literal, range: nil)
        let dayWithOutDate = String((selectedDay?.dropFirst(3))!)
        cell.dateLabel.text = dayWithOutDate
        cell.serviceLabel.text = getProviderBookingData[indexPath.row].categoryName
        cell.locationLabel.text = getProviderBookingData[indexPath.row].location
        let ImageUrl = URL(string: getProviderBookingData[indexPath.row].image ?? "")
        cell.serviceImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        cell.serviceImageView?.sd_setImage(with: ImageUrl) { (image, error, cache, urls) in
            if (error != nil) {
                cell.serviceImageView.image = UIImage(named: "outdoor_home_service")
            } else {
                cell.serviceImageView.image = image
            }
        }
       // cell.serviceImageView.sd_setImage(with: ImageUrl, placeholderImage:UIImage(contentsOfFile:"outdoor_home_service.png"))

        cell.nameLabel.text = getProviderBookingData[indexPath.row].userDetails?.name
        cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let profileUrl = URL(string: getProviderBookingData[indexPath.row].userDetails?.image ?? "")
        cell.profileImageView?.sd_setImage(with: profileUrl) { (image, error, cache, urls) in
            if (error != nil) {
                cell.profileImageView.image = UIImage(named: "user.profile.icon")
            } else {
                cell.profileImageView.image = image
            }
        }
       // cell.profileImageView.sd_setImage(with: profileUrl, placeholderImage:UIImage(contentsOfFile:"user.profile.icon.png"))
        let date = getDate(date: getProviderBookingData[indexPath.row].booking_date ?? "")
        let time = getTime(time: getProviderBookingData[indexPath.row].time ?? "")
        let dateTime = time! + " : " + date!
        cell.timeLabel.text = dateTime
        cell.lbl_40m.text = getProviderBookingData[indexPath.row].totalTime ?? ""
        
        cell.view_Rating.rating = Double((getProviderBookingData[indexPath.row].userDetails?.rating ?? 0.0) as Float)
        
        let arr = getProviderBookingData[indexPath.row].subcategoryId
               cell.arrSubCategory = arr ?? []
        cell.lbl_price.text = getProviderBookingData[indexPath.row].price
        cell.lbl_40m.isHidden = true
        let userId = getProviderBookingData[indexPath.row].userDetails?.userId
        UserStoreSingleton.shared.bookingID = userId
        cell.copybtn.addTarget(self, action: #selector(copy_btn_tapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func copy_btn_tapped(_ sender: UIButton){
        let location = getProviderBookingData[sender.tag].location
        UIPasteboard.general.string = location
        showMessage("Text copied")
    }
}
