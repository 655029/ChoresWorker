//
//  ChooseYourServiceViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/04/21.
//

import UIKit
import SDWebImage
import SwiftyJSON


struct Service {
    var title: String
    var image: UIImage

    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }

    static var services: [Service] {
        var services: [Service] = []
        services.append(Service(title: "Outdoor Home Service", image: UIImage(named: "outdoor_home_service")!))
        services.append(Service(title: "House cleaning", image: UIImage(named: "house_cleaning_service")!))
        services.append(Service(title: "Item Disposal", image: UIImage(named: "item_disposal_service")!))
        services.append(Service(title: "Custom", image: UIImage(named: "custome_service")!))
        return services
    }
}

class ChooseYourServiceViewController: ServiceBaseViewController {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var serviceTextFeild: UITextField!

    // MARK: - Properties
    var categoryDict = NSArray()
    var serviceCategoryname = String()
    var serviceCategoryId = Int()
    var selectedIndexPaths = [String]()
    //
    var dataarray = [CategoryListData]()
    override var navigationController: BaseNavigationController? {
        return super.navigationController
    }

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppString.CHOOSE_YOUR_SERVICE
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stepLabel.text = "2/5"
        serviceTextFeild.isEnabled = false
        serviceTextFeild.text = UserStoreSingleton.shared.Address
        if Reachability.isConnectedToNetwork(){
            getCategoriesList()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in

            }])
        }
        //        let firstVc = Storyboard.Home.viewController(for: HomeViewController.self)
        //        firstVc.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(named: "home"), tag: 0)
        //        let firstNavVc = BaseNavigationController(rootViewController: firstVc)
        //
        //        let secondVc = Storyboard.Booking.viewController(for: BookingsViewController.self)
        //        secondVc.tabBarItem = UITabBarItem(title: "BOOKINGS", image: UIImage(named: "booking.tab.icon"), tag: 0)
        //        let secondNavVc = BaseNavigationController(rootViewController: secondVc)
        //
        //        let thirdVc = Storyboard.Booking.viewController(for: BookingHistoryViewController.self)
        //        thirdVc.tabBarItem = UITabBarItem(title: "HISTORY", image: UIImage(named: "history.tab"), tag: 0)
        //        let thirdNavVc = BaseNavigationController(rootViewController: thirdVc)
        //
        //        viewControllers = [firstNavVc, secondNavVc, thirdNavVc]
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
       selectedIndexPaths.removeAll()
        if Reachability.isConnectedToNetwork(){
            getCategoriesList()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in

            }])
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Layout
    func getCategoriesList(){
        self.showActivity()
        let url = URL(string: "http://3.18.59.239:3000/api/v1/categories-list")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data{
                do {
                    let json =  try JSONDecoder().decode(CategoryListModel.self, from: data )
                    debugPrint(json)
                    DispatchQueue.main.async {
                        self.dataarray = json.data ?? []
                        self.hideActivity()
                        self.collectionView.reloadData()
                    }

                } catch {
                    print(error)
                }
            }
        }.resume()
    }


    // MARK: - User Interaction
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if selectedIndexPaths.isEmpty == true {
            showMessage("Select atleast one Category")
        } else {

        let vc = Storyboard.Service.viewController(for: ChooseSubServicesViewController.self)
        vc.categoryId = serviceCategoryId
        self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    @IBAction func dropDownLocationButtonAction(_ sender: UIButton) {
        navigate(.chooseLocationOnMap)
    }
    // MARK: - Additional Helpers

}

// MARK: - UICollectionViewDelegate

extension ChooseYourServiceViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            serviceCategoryId = dataarray[indexPath.row].categoryId ?? 0
            serviceCategoryname = dataarray[indexPath.row].categoryName ?? ""
            UserStoreSingleton.shared.categeoryName = dataarray[indexPath.row].categoryName
            UserStoreSingleton.shared.categeoryID = dataarray[indexPath.row].categoryId
        let cell = collectionView.cellForItem(at: indexPath) as! ServiceCollectionViewCell
        let textForAlert = cell.serviceTitleLabel.text
        selectedIndexPaths.append(textForAlert!)
    }
}

// MARK: - UICollectionViewDataSource

extension ChooseYourServiceViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataarray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as? ServiceCollectionViewCell
        //let categoryname = (categoryDict.object(at: indexPath.row) as? NSDictionary)?["categoryName"] as? String
        cell?.serviceTitleLabel.text = dataarray[indexPath.row].categoryName
        let imageUrl = URL(string: dataarray[indexPath.row].categoryImage ?? "" )
        cell?.serviceImageView.sd_setImage(with: imageUrl, placeholderImage:UIImage(contentsOfFile:"app.fill.png"))
        cell?.configure(with: Service.services[indexPath.item])

        return cell!
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChooseYourServiceViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) - 16
        return CGSize(width: (width / 2), height: (width / 2))
    }

    @objc func isSelectedToggl(_ Sender: UIButton) {
        Sender.isSelected.toggle()

    }
}

