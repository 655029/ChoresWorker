//
//  ChoresIDViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import SDWebImage
class ChoresIDViewController: BaseViewController {
    
    @IBOutlet var img_Approved: UIImageView!
    @IBOutlet var img_Pending: UIImageView!
    @IBOutlet var profileIdImageView: UIImageView!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var view_IdCardView: UIView!
    var jsonData = [providerVerifyData]()
    var dataarray = [CategoryListData]()
    var providerData = [GetProviderCategoryModelData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.darkNavigationBar()
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Chores ID Card"
        self.img_Pending.isHidden = true
        self.img_Approved.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        getProviderCategory()
        if Reachability.isConnectedToNetwork(){
            choresIdCard()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
            }])
        }
    }
    
    @IBAction func btn_Share(_ sender: Any) {
        let img = view_IdCardView.createImage ?? UIImage()
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [img], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToFacebook]
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
   
    
    func choresIdCard(){
        showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetUserProfileModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.nameLabel.text = json.data?.first_name
                    self.mobileLabel.text = json.data?.phone
                    let photoUrl = URL(string: "\(json.data?.image ?? "")")
                    self.profileIdImageView?.sd_setImage(with: photoUrl) { (image, error, cache, urls) in
                        if (error != nil) {
                            self.profileIdImageView.image = UIImage(named: "outdoor_home_service")
                        } else {
                            self.profileIdImageView.image = image
                        }
                    }
                    let providerId = "\(json.data?.userId ?? 0)"
                    self.providerDocumentAPI(providerId: providerId)
                }
            } catch {
                self.hideActivity()
                print(error)
            }
        }
        task.resume()
    }
    func providerDocumentAPI(providerId : String){
        //showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-provider-document/" + providerId)!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(ProviderModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                   // self.hideActivity()
                    if json.status == 200{
                        if json.data?.proof_image_one_status == "verified" && json.data?.proof_image_two_status == "verified"{
                            self.img_Pending.isHidden = true
                            self.img_Approved.isHidden = false
                        }else{
                            self.img_Pending.isHidden = false
                            self.img_Approved.isHidden = true
                        }
                    } else{
                        self.showMessage(json.message ?? "")
                    }
                }
            } catch {
               // self.hideActivity()
                print(error)
            }
        }
        task.resume()
    }
    func getProviderCategory(){
        //showActivity()
        var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-provider-category")!,timeoutInterval: Double.infinity)
        request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json =  try JSONDecoder().decode(GetProviderCategoryModel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.categoryLabel.text = json.data?.categoryName

                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
extension UIView {
    var createImage: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
}

