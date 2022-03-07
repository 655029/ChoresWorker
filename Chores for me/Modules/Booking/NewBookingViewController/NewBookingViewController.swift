//
//  NewBookingViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit
import SDWebImage
protocol fromNotification {
    func dissmissNotification(jobId: Int)
}


class NewBookingViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var lbl_service: UILabel!
    @IBOutlet weak var lab_Name: UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_DateTime: UILabel!
    @IBOutlet weak var lbl_Day: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var img_service: UIImageView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak var view_Rating: FloatRatingView!

    // MARK: - Properties
    var job_Id : Int?
    var arrSubCategoy: [SubcategoryIdData]?
    var json : JsonNotificationData!
    var viewJobString: String?
    var delegate : fromNotification?
    var sSImage = UIImage()

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector:#selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "requestBoiking"), object: nil)
        collectionView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        navigationItem.setHidesBackButton(true, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        job_Id = UserStoreSingleton.shared.id ?? 0
        GetReqOnProviderSide(job: job_Id ?? 0)
        navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewWillLayoutSubviews() {
        backGroundImage.image = sSImage
    }

    // MARK: - User Interaction
    @IBAction func skipButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func viewJobButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        self.delegate?.dissmissNotification(jobId: self.job_Id ?? 0)
    }


    @IBAction func confirmJobButtonAction(_ sender: Any) {
        self.JobStatusAPI(status: "accept")
    }

    // MARK: - Additional Helpers
    func GetReqOnProviderSide(job:Int){
        // showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-jobDetails/" + "\(job)")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let data =  try JSONDecoder().decode(JsonNotificationDataModel.self, from: data ?? Data())
                self.json = data.data
                DispatchQueue.main.async {
                    self.lab_Name.text = self.json?.userDetails?.first_name
                    self.lbl_service.text = self.json?.categoryName
                    self.lbl_Location.text = self.json?.location
                   // var selectedDay = self.json?.day
                   // selectedDay = selectedDay?.replacingOccurrences(of: " \n", with: "", options: NSString.CompareOptions.literal, range: nil)
                    let selectedDay = self.json.day
                    let day = String(selectedDay!.dropFirst(2))
                    self.lbl_Day.text = day
                    let date = getDate(date: self.json?.booking_date ?? "")
                    let time = self.json?.time ?? ""
                    let dateTime = time + " : " + date!
                    self.lbl_DateTime.text = dateTime
                    self.lbl_Price.text = self.json?.price
                    self.view_Rating.rating = Double((self.json.providerDetails?.rating ?? 0.0) as Float)
                    let serviceimageUrl = URL(string: "\(self.json?.image ?? "")")
                    self.img_service?.sd_setImage(with: serviceimageUrl) { (image, error, cache, urls) in
                        if (error != nil) {
                            self.img_service.image = UIImage(named: "outdoor_home_service")
                        } else {
                            self.img_service.image = image
                        }
                    }
                    let imageUrl = URL(string: "\(self.json?.userDetails?.image ?? "")")
                    self.img_profile?.sd_setImage(with: imageUrl) { (image, error, cache, urls) in
                        if (error != nil) {
                            self.img_profile.image = UIImage(named: "user.profile.icon")
                        } else {
                            self.img_profile.image = image
                        }
                    }
                    self.arrSubCategoy = self.json?.subcategoryId
                    self.collectionView.reloadData()
                }
            } catch {
                self.hideActivity()
                print(error)
            }
        }
        task.resume()
    }


    func JobStatusAPI(status: String){
        let parameters = ["jobId": json.jobId!,
                          "UserId":json.UserId!,
                          "providerId":json.providerDetails?.UserId ?? 0,
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
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(UpdateJobModel.self, from: data)

                    DispatchQueue.main.async {
                        if json.status == 200{
                            self.showMessage(json.message ?? "")
                            self.dismiss(animated: false, completion: nil)
//                            self.delegate?.dissmissNotification(jobId: self.job_Id ?? 0)

                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }

}

// MARK: - UICollectionViewDelegate

extension NewBookingViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension NewBookingViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubCategoy?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingRequestServiceCollectionViewCell", for: indexPath) as? BookingRequestServiceCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.subcatgeoryLabel.text = arrSubCategoy?[indexPath.row].name
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewBookingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}
