//
//  LogoutViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Alamofire
import Designable

class LogoutViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewLogout: DesignableView!
    
    var image = UIImage()    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
    }
    override func viewDidLayoutSubviews() {
        imageView.image = image
    }
    
    
    //MARK: - Interface Builder Actions
    
    
    @IBAction func logOutbutton(_ sender: Any) {
        LogoutApi()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        RootRouter().loadMainHomeStructure()
        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func popupAlert(){
        let alert = UIAlertController(title: "Chores for Me",
                                      message: "Are you sure you want to logout?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.LogoutApi()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
        }))
        alert.view.tintColor = UIColor.black
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    func LogoutApi() {
        var url:String!
        url = "http://3.18.59.239:3000/api/v1/logout"
        let headers: HTTPHeaders = ["Authorization":UserStoreSingleton.shared.Token ?? ""]
        
        Alamofire.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result{
                case .success(let json):
                    print(json)
                    DispatchQueue.main.async {
                        print(json)
                        self.logOut()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    @objc func logOut(){
        guard UIApplication.shared.windows.first(where: {$0.isKeyWindow}) != nil else { return}
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        if #available(iOS 13.0, *) {
            let rootVC = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(rootVC, animated: true)
            
        } else {
            let rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(rootVC, animated: true)
        }
        UserStoreSingleton.shared.isLoggedIn = false
    }
    
    
}

