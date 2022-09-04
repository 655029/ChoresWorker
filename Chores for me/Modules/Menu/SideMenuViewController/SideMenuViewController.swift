//
//  SideMenuViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Alamofire
import SDWebImage


class SideMenuViewController: UIViewController {
    
    enum Options: CaseIterable {
        case  id
        case jobStatus
        case notification
        case share
        case logout
        
        var image: UIImage? {
            switch self {
            case .id:
                return UIImage(named: "payemnt.card")
            //            case .paymentDetails:
            //                return UIImage(named: "id")
            case .jobStatus:
                return UIImage(named: "user")
            case .notification:
                return UIImage(named: "notification.bel")
            case .share:
                return UIImage(named: "share")
            case .logout:
                return UIImage(named: "logout")
                
            }
        }
        
        var title: String {
            switch self {
            case .id:
                return "Chores ID-Card"
            //            case .paymentDetails:
            //                return "Add Payment Details"
            case .jobStatus:
                return "Update Details"
            case .notification:
                return "Notifications"
            case .share:
                return "Share"
            case .logout:
                return "Logout"
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var gamilLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var view_Rating: FloatRatingView!
    // MARK: - Properties
    var profileData = [GetUserProfileData]()
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        navigationController?.navigationBar.isHidden = true
        if Reachability.isConnectedToNetwork(){
            getUserProfile()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                
            }])
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = UserStoreSingleton.shared.name
        if Reachability.isConnectedToNetwork(){
            getUserProfile()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
            }])
        }
    }
    // MARK: - Layout
    
    // MARK: - User Interaction
    @IBAction func editButtonAction(_ sender: UIButton) {
        navigate(.editProfile)
    }

    // MARK: - Additional Helpers
    func getUserProfile(){
        showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //self.hideActivity()
            do {
                let json =  try JSONDecoder().decode(GetUserProfileModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.view_Rating.rating = Double(json.data?.avgRatings ?? Double(0.0))
                    self.nameLabel.text = json.data?.first_name
                    self.gamilLabel.text = json.data?.email
                    UserStoreSingleton.shared.lastname = json.data?.last_name
                    _ = json.data?.image
                    let photoUrl = URL(string: "\(json.data?.image ?? "")")
                    self.profileImage?.sd_setImage(with: photoUrl) { (image, error, cache, urls) in
                        if (error != nil) {
                            self.profileImage.image = UIImage(named: "user.profile.icon")
                        } else {
                            self.profileImage.image = image
                        }
                    }
                    UserStoreSingleton.shared.name = json.data?.first_name
                    UserStoreSingleton.shared.profileImage = json.data?.image
                    UserStoreSingleton.shared.userID = json.data?.userId
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

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch Options.allCases[indexPath.row] {
        case .id:
            //            dismiss(animated: true)
            navigate(.choresID)
        //        case .paymentDetails:
        //            dismiss(animated: true)
        //            navigate(.choresID)
        case .jobStatus:
            //            dismiss(animated: true)
            navigate(.chooseYourCity)
        case .notification:
            //            dismiss(animated: true)
            navigate(.notifications)
        case .share:
          //  dismiss(animated: true)
            let name = "SHARE THE APP WITH YOUR FRIENDS"
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [name], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.postToFacebook]
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        //            navigate(.choresID)
        case .logout:
           let screenShotImage = TakeScreenShotImage.shareInstance.takeScreenshot(false) ?? UIImage()
            navigate(.logout(image: screenShotImage))
        }
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Options.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") else {
            return UITableViewCell()
        }
        cell.imageView?.image = Options.allCases[indexPath.row].image
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.font = AppFont.font(style: AppFont.Poppins.medium, size: 17)
        cell.textLabel?.textColor = AppColor.primaryLabelColor
        cell.textLabel?.text = Options.allCases[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


