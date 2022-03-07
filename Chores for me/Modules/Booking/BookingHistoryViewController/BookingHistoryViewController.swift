//
//  BookingHistoryViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Designable
import SDWebImage
class BookingHistoryViewController: HomeBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var bookingHistoryTableView: UITableView!
    @IBOutlet weak var locationButton: DesignableButton!
    @IBOutlet var view_OopsViewHistory: UIView!
    
    // MARK: - Properties
    var bookingHistoryResponseData = [GetReqOnProviderSideModelData]()
    static var locationForBookingHistory: String?
    
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "Forground"), object: nil)
        NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)
        locationButton.addSpaceBetweenImageAndTitle(spacing: 10.0)
        navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "")"
        bookingHistoryTableView.delegate = self
        bookingHistoryTableView.dataSource = self
        bookingHistoryTableView.separatorStyle = .none
        bookingHistoryTableView.register(UINib(nibName: "BookingsHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsHistoryTableViewCell")
        bookingHistoryTableView.rowHeight = UITableView.automaticDimension
        bookingHistoryTableView.estimatedRowHeight = 300
       // self.locationButton.setTitle(UserStoreSingleton.shared.Address, for: .normal)
        bookingHistory()
//        if Reachability.isConnectedToNetwork(){
//            bookingHistory()
////        }else{
//            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
//            }])
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)
        navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "")"
        tabBarController?.tabBar.isHidden = false
        self.locationButton.setTitle(BookingHistoryViewController.locationForBookingHistory, for: .normal)
            bookingHistory()
        self.bookingHistoryTableView.reloadData()

        
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
    

    // MARK: - Layout
    
    
    
    // MARK: - User Interaction
    
    
    // MARK: - Additional Helpers
    func bookingHistory(){
        showActivity()
//        self.bookingHistoryResponseData.removeAll()
        let parameters = ["signupType":"1"]
        let url = URL(string: "http://3.18.59.239:3000/api/v1/jobs-history")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.hideActivity()
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(GetReqOnProviderSideModel.self, from: data)
                    DispatchQueue.main.async {
                        self.hideActivity()
                            self.bookingHistoryResponseData = json.data!
                        if self.bookingHistoryResponseData.count == 0 {
                         //  self.showMessage(json.message ?? "")
                            self.bookingHistoryResponseData = []
                            self.view_OopsViewHistory.isHidden = false
                            self.bookingHistoryTableView.isHidden = true
                        } else{
                            self.view_OopsViewHistory.isHidden = true
                            self.bookingHistoryTableView.isHidden = false
                            
                        }
                        self.bookingHistoryTableView.reloadData()
                    }
                }catch{
                    self.hideActivity()
                    self.showMessage("Error occured")
                }
            }
        }.resume()
    }
}
// MARK: - UITableViewDelegate



// MARK: - UITableViewDataSource

extension BookingHistoryViewController: UITableViewDataSource ,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingHistoryResponseData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsHistoryTableViewCell") as? BookingsHistoryTableViewCell else {
            return UITableViewCell()
        }
        if bookingHistoryResponseData[indexPath.row].jobStatus == "cancel"{
            cell.historyCancelLabel.isHidden = false
            cell.historyCheckButton.isHidden = true
        }else if bookingHistoryResponseData[indexPath.row].jobStatus?.lowercased() == "complete" {
            cell.historyCancelLabel.isHidden = true
            cell.historyCheckButton.isHidden = false
        }
        let selectedDay = bookingHistoryResponseData[indexPath.row].day
        let day = String(selectedDay!.dropFirst(2))
        let space = day.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.historyTimeLabel.text = bookingHistoryResponseData[indexPath.row].day
        cell.historySecviceLbl.text = bookingHistoryResponseData[indexPath.row].categoryName
        cell.historyLocationLabel.text = bookingHistoryResponseData[indexPath.row].location
        cell.priceLabel.text = bookingHistoryResponseData[indexPath.row].price
        cell.secondLabel.text = bookingHistoryResponseData[indexPath.row].totalTime
        let arr = bookingHistoryResponseData[indexPath.row].subcategoryId
        cell.historyArrSubCategory = arr ?? []
        cell.historyServiceImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let serviceimageUrl = URL(string: "\(bookingHistoryResponseData[indexPath.row].image ?? "")")
        cell.historyServiceImageView?.sd_setImage(with: serviceimageUrl) { (image, error, cache, urls) in
            if (error != nil) {
                cell.historyServiceImageView.image = UIImage(named: "outdoor_home_service")
            } else {
                cell.historyServiceImageView.image = image
            }
        }
        cell.historyNameLabel.text = self.bookingHistoryResponseData[indexPath.row].userDetails?.first_name ?? ""
        let profileUrl = URL(string: "\(bookingHistoryResponseData[indexPath.row].userDetails?.image ?? "")")
        cell.historyProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.historyProfileImageView?.sd_setImage(with: profileUrl) { (image, error, cache, urls) in
            if (error != nil) {
                cell.historyProfileImageView.image = UIImage(named: "user.profile.icon")
            } else {
                cell.historyProfileImageView.image = image
            }
        }
        let date = getDate(date: bookingHistoryResponseData[indexPath.row].booking_date ?? "")
        let time =  bookingHistoryResponseData[indexPath.row].time ?? ""
        let dateTime = time + " : " + date!
        cell.historyDateLabel.text = dateTime
        cell.copybtn.addTarget(self, action: #selector(copy_btn_tapped), for: .touchUpInside)
        cell.view_Rating.rating = Double((bookingHistoryResponseData[indexPath.row].userDetails?.rating ?? 0.0) as Float)
        cell.historyCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigate(.jobStatus(jobId: bookingHistoryResponseData[indexPath.row].jobId ?? 0))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func copy_btn_tapped(_ sender:UIButton){
        let location = bookingHistoryResponseData[sender.tag].location
        UIPasteboard.general.string = location
            self.showMessage("Text Copid")
            
    }
}

extension BookingHistoryViewController : fromNotification {
    func dissmissNotification(jobId: Int) {
        print("------Working-----")
        self.navigate(.jobStatus(jobId: jobId))
    }
}
