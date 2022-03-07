//
//  NotificationsViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_Backgroubd : UIView!
    // MARK: - Properties
    var arrNotifiction = [NotificationData]()
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.darkNavigationBar()
        navigationItem.title = "Notification"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.separatorColor = UIColor.black
        tableView.separatorStyle = .singleLine
        if Reachability.isConnectedToNetwork(){
           GetNotifications()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                
            }])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true

    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    @IBAction func rateButtonAction(_ sender: UIButton) {
        let screenShotImage = TakeScreenShotImage.shareInstance.takeScreenshot(false)
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let SecondVc = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        SecondVc.rData = arrNotifiction[sender.tag]
        SecondVc.imge = screenShotImage!
        SecondVc.modalPresentationStyle = .popover
        self.present(SecondVc, animated: true, completion: nil)
    }
    
    // MARK: - Additional Helpers
    //
    func GetNotifications(){
        showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-all-notification/1")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(NotificationModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.arrNotifiction = []
                    if json.status == 200 {
                        if json.data?.count == 0{
                            self.showMessage(json.message ?? "")
                        }else{
                            self.arrNotifiction = json.data!
                            self.tableView.isHidden = false
                        }
                    }else{
                        self.showMessage(json.message ?? "")
                        self.tableView.isHidden = true
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
}

// MARK: - UITableViewDelegate

extension NotificationsViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotifiction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as? NotificationTableViewCell else {
            return UITableViewCell()
        }
        cell.btn_Rate.isHidden = true
        cell.lbl_TimeAgo.isHidden = true
        cell.lbl_Notification.text = arrNotifiction[indexPath.row].text
        if arrNotifiction[indexPath.row].type?.lowercased() == "job-rating-by-customer" {
            cell.btn_Rate.isHidden = false
            cell.btn_Rate.tag = indexPath.row
            cell.btn_Rate.addTarget(self, action: #selector(rateButtonAction), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

