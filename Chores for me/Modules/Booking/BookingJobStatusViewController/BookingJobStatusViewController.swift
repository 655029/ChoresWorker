//
//  BookingJobStatusViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit
import Designable
import SDWebImage

class BookingJobStatusViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var btn_StartWork: UIButton!
    @IBOutlet weak var btn_Confirm: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var view_StartComplete: UIView!
    @IBOutlet weak var view_CancelConfirm: UIView!
    @IBOutlet weak var btn_Call: UIButton!
    @IBOutlet weak var btn_CancelRequest: DesignableButton!
    @IBOutlet weak var img_ServiceImage: UIImageView!
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var btn_Complete: UIButton!
    
    @IBOutlet weak var lbl_ServiceAddres: UILabel!
    @IBOutlet weak var lbl_ServiceDay: UILabel!
    @IBOutlet weak var lbl_ServiceAmmount: UILabel!
    @IBOutlet weak var lbl_DateTime: UILabel!
    
    @IBOutlet weak var servicesCollectioView: UICollectionView!
    @IBOutlet weak var progressStatusCollectioView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var view_Rating: FloatRatingView!
    @IBOutlet var btn_Copy: UIButton!
    // MARK: - Properties
    var arrayOfJobProgress: [String] = []
    var selectedStatus = Int()
    var subcategoryIdData = [SubcategoryIdData]()
    fileprivate let application = UIApplication.shared
    var noteData : JsonNotificationData!
    var dicData : GetReqOnProviderSideModelData!
    var jobId = Int()
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetReqOnProviderSide()
        navigationItem.title = "Job Status"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        btn_Copy.addTarget(self, action: #selector(copy_btn_Tapped(_:)), for: .touchUpInside)
        if let flowLayout = servicesCollectioView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        navigationController?.darkNavigationBar()
        servicesCollectioView.delegate = self
        servicesCollectioView.dataSource = self
        servicesCollectioView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")
        progressStatusCollectioView.delegate = self
        progressStatusCollectioView.dataSource = self
        progressStatusCollectioView.register(UINib(nibName: "JobStatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JobStatusCollectionViewCell")
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        // navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    
    // MARK: - Layout
    @objc func copy_btn_Tapped(_ sender : UIButton){
        let location = noteData.location
        UIPasteboard.general.string = location
        showMessage("Text Copied")
    }
    
    // MARK: - User Interaction
    @IBAction func btn_call(_ sender: UIButton){
        let phone = "tel://\(noteData.userDetails?.phone ?? "")"
        print(phone)
        if let phoneUrl = URL(string: "tel://\(noteData.userDetails?.phone ?? "0123456789")") {
            if application.canOpenURL(phoneUrl) {
                application.open(phoneUrl, options: [:], completionHandler: nil)
            }
            else {
                openAlert(title: "Alert", message: "You don,t have phone call access", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                }])
            }
        }
    }
    
    @IBAction func btn_CancelReason(_ sender: UIButton) {
        self.JobStatusAPI(status: "cancel")
    }
    @IBAction func btn_StartWork(_ sender: UIButton) {
        self.JobStatusAPI(status: "inprogress")
    }
    @IBAction func btn_Complete(_ sender: UIButton) {
        self.JobStatusAPI(status: "complete")
    }
    
    @IBAction func tapCancellRequestButton(_ sender: Any) {
        navigate(.cancelJobRequest(jobId: noteData.jobId ?? 0, user_id: noteData.userDetails?.UserId ?? 0))
    }
    
    @IBAction func tapConfirmButton(_ sender: Any) {
        self.JobStatusAPI(status: "accept")
    }
    // MARK: - Additional Helpers
    
    func JobStatusAPI(status: String){
        showActivity()
        let parameters = ["jobId": noteData.jobId!,
                          "UserId":noteData.UserId ?? 0,
                          "providerId":noteData.providerDetails?.UserId ?? 0,
                          "jobStatus":status] as [String : Any]
        let url = URL(string: "http://3.18.59.239:3000/api/v1/updatejob")
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
            self.hideActivity()
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(UpdateJobModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        if json.status == 200{
                            self.showMessage(json.message ?? "")
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                    self.hideActivity()
                }
            }
        }.resume()
    }
    func GetReqOnProviderSide(){
        showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/" + "\(jobId )")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let data =  try JSONDecoder().decode(JsonNotificationDataModel.self, from: data ?? Data())
                self.noteData = data.data
                DispatchQueue.main.async {
                    self.hideActivity()
                    switch self.noteData.jobStatus {
                    case JobStatus.JOB_REQUEST:
                        self.selectedStatus = 0
                    case JobStatus.JOB_ACCEPT:
                        self.selectedStatus = 1
                    case JobStatus.JOB_PROGRESS:
                        self.selectedStatus = 2
                    case JobStatus.JOB_COMPLETED:
                        self.selectedStatus = 3
                    case JobStatus.JOB_REJECT, JobStatus.JOB_CANCELLED:
                        self.selectedStatus = 4
                    default:
                        break
                    }
                    
                    self.arrayOfJobProgress.append("Job progress")
                    self.arrayOfJobProgress.append("Accepted")
                    self.arrayOfJobProgress.append("work started")
                    self.arrayOfJobProgress.append("Completed")
                    if self.selectedStatus == 4 {
                        self.arrayOfJobProgress.removeAll()
                        self.arrayOfJobProgress.append("Job progress")
                        self.arrayOfJobProgress.append("Cancel")
                    }
                    
                    let imageUrl = URL(string: self.noteData.userDetails?.image ?? "")
                    self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.profileImageView?.sd_setImage(with: imageUrl) { (image, error, cache, urls) in
                        if (error != nil) {
                            self.profileImageView.image = UIImage(named: "user.profile.icon")
                        } else {
                            self.profileImageView.image = image
                        }
                    }
                    self.nameLabel.text = self.noteData.userDetails?.name
                    self.locationLabel.text = self.noteData.location
                    self.discriptionLabel.text = self.noteData.description
                    self.subcategoryIdData = self.noteData.subcategoryId ?? self.subcategoryIdData
                    self.lbl_ServiceAddres.text = self.noteData.location
                    self.lbl_ServiceName.text = self.noteData.categoryName
                    var selectedDay = self.noteData.day
                    selectedDay = selectedDay!.replacingOccurrences(of: " \n", with: "", options: NSString.CompareOptions.literal, range: nil)
                    let dayWithOutDate = String((selectedDay?.dropFirst(3))!)
                    self.lbl_ServiceDay.text = dayWithOutDate
                    self.lbl_ServiceAmmount.text = self.noteData.price
                    
                    let date = getDate(date: self.noteData.createdAt ?? "")
                    let time = getTime(time: self.noteData.time ?? "")
                    let dateTime = time! + " : " + date!
                    self.lbl_DateTime.text = dateTime
                    self.view_Rating.rating = Double((self.noteData.providerDetails?.rating ?? 0.0) as Float)
                    let imageUrlService = URL(string: self.noteData.image ?? "")
                    self.img_ServiceImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.img_ServiceImage?.sd_setImage(with: imageUrlService) { (image, error, cache, urls) in
                        if (error != nil) {
                            self.img_ServiceImage.image = UIImage(named: "outdoor_home_service")
                        } else {
                            self.img_ServiceImage.image = image
                        }
                    }
                    
                    if self.selectedStatus == 0 {
                        self.btn_Call.isHidden = true
                        self.view_StartComplete.isHidden = true
                        self.view_CancelConfirm.isHidden = false
                    }
                    else if self.selectedStatus == 1 {
                        self.btn_CancelRequest.isHidden = false
                        self.view_StartComplete.isHidden = false
                        self.view_CancelConfirm.isHidden = true
                        self.btn_Complete.isHidden = true
                    }
                    else if self.selectedStatus == 2 {
                        self.view_StartComplete.isHidden = false
                        self.view_CancelConfirm.isHidden = true
                        self.btn_StartWork.isHidden = true
                    }
                    else if self.selectedStatus == 3 {
                        self.view_StartComplete.isHidden = true
                        self.view_CancelConfirm.isHidden = true
                        self.btn_Call.isHidden = true
                    }
                    else if  self.selectedStatus == 4 {
                        self.view_StartComplete.isHidden = true
                        self.view_CancelConfirm.isHidden = true
                        self.progressStatusCollectioView.isScrollEnabled = false
                        self.btn_Call.isHidden = true
                    }
                    self.progressStatusCollectioView.reloadData()
                    self.servicesCollectioView.reloadData()
                }
            } catch {
                print(error)
                self.hideActivity()
            }
        }
        task.resume()
    }
    
}


// MARK: - UICollectionViewDelegate

extension BookingJobStatusViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDataSource

extension BookingJobStatusViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == progressStatusCollectioView {
            return arrayOfJobProgress.count
        }
        return subcategoryIdData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == progressStatusCollectioView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobStatusCollectionViewCell", for: indexPath) as? JobStatusCollectionViewCell else {
                fatalError()
            }
            DispatchQueue.main.async {           
            var isPrevious = false
            cell.jobProgressImageView.tintColor = UIColor.systemGray
            if indexPath.item == 0 {
                cell.leftBarView.isHidden = true
                
                if self.selectedStatus >= 1 {
                    isPrevious = true
                }
                self.StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: false, isGreenRight: isPrevious)
            }
            
            if indexPath.item == 1 {
                if self.selectedStatus >= 2 {
                    isPrevious = true
                }
                self.StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: true, isGreenRight: isPrevious)
                
            }
            if indexPath.item == 2 {
                if self.selectedStatus >= 3 {
                    isPrevious = true
                }
                self.StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: true, isGreenRight: isPrevious)
            }
            
            if indexPath.item == 3 {
                cell.rightBarView.isHidden = true
                self.StatusChange(cell: cell, indexSelected: indexPath.item, isGreenLeft: true, isGreenRight: false)
            }
                if self.selectedStatus == 4 {
                cell.jobProgressLabel.textColor = .red
                cell.jobProgressImageView.tintColor = UIColor.systemGreen
                cell.rightBarView.backgroundColor = UIColor.systemGreen
                cell.leftBarView.backgroundColor = UIColor.systemGreen
                if indexPath.row == 1 {
                    cell.rightBarView.isHidden = true
                    cell.jobProgressImageView.image = UIImage.init(named: "remove")
                    cell.jobProgressImageView.layer.cornerRadius = 15
                }
            }
                cell.jobProgressLabel.text = self.arrayOfJobProgress[indexPath.item]
            }
            return cell
           
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingRequestServiceCollectionViewCell", for: indexPath) as? BookingRequestServiceCollectionViewCell else {
            fatalError()
        }
        cell.subcatgeoryLabel.text = subcategoryIdData[indexPath.row].name
        
        return cell
    }
    func StatusChange(cell: JobStatusCollectionViewCell,indexSelected: Int, isGreenLeft: Bool, isGreenRight: BooleanLiteralType) {
        
        cell.jobProgressImageView.image = UIImage.init(named: "circle.empty")
        cell.jobProgressImageView.tintColor = UIColor.systemOrange
        
        if selectedStatus >= indexSelected {
            
            cell.jobProgressImageView.image = UIImage.init(named: "checked")
            cell.jobProgressImageView.tintColor = UIColor.systemOrange
            
            if selectedStatus == indexSelected {
                cell.jobProgressImageView.image = UIImage.init(named: "checked")
                cell.jobProgressImageView.tintColor = UIColor.systemGreen
            }
            
            if isGreenRight {
                cell.rightBarView.backgroundColor = UIColor.systemGreen
            }
            if isGreenLeft {
                cell.leftBarView.backgroundColor = UIColor.systemGreen
            }
        }
        else {
            cell.jobProgressImageView.tintColor = UIColor.systemGray
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BookingJobStatusViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == progressStatusCollectioView {
            return 0
        }
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == progressStatusCollectioView {
            return 0
        }
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == progressStatusCollectioView {
            if selectedStatus == 4 {
                return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
            }
            return CGSize(width: 100, height: collectionView.frame.height)
        }
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}
func getDate(date: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //    dateFormatter.timeZone = TimeZone.current
    //    dateFormatter.locale = Locale.current
    let dateValue = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "dd-MM-yyyy"
    return dateFormatter.string(from: dateValue ?? Date())
}

func getTime(time: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let dateValue = dateFormatter.date(from: time)
    dateFormatter.dateFormat = "hh:mm a"
    return dateFormatter.string(from: dateValue ?? Date())
}


