//
//  BaseViewController.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView

class BaseViewController: UIViewController {

    // MARK: - Outlets

    // MARK: - Properties
    let cropImagePicker = UIImagePickerController()
 //   var authRouter : HTTPRequest<AuthenticationEndPoint>?

    override var navigationController: BaseNavigationController? {
        return super.navigationController as? BaseNavigationController
        }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
      //  CheckTimeFunc()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Layout
    
    // MARK: - User Interaction

    // MARK: - Additional Helpers
    
    
    // MARK: - Additional Helpers
    func showImagePicker(){
           let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           alertController.popoverPresentationController?.sourceView = self.view
           alertController.popoverPresentationController?.sourceRect = CGRect(origin: self.view.center, size: CGSize.zero)
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
                   self.cropImagePicker.sourceType = .camera
                   self.present(self.cropImagePicker, animated: true, completion: nil)
               })
           }
           alertController.addAction(UIAlertAction(title: NSLocalizedString("Gallery", comment: ""),style: .default) { _ in
               self.cropImagePicker.sourceType = .photoLibrary
               self.present(self.cropImagePicker, animated: true, completion: nil)
           })
           alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
           }))
           self.present(alertController, animated: true, completion: nil)
       }
}


extension UIViewController {
    func CheckTimeFunc(){
        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let currentHour = componets.hour
        if currentHour! < 7 || currentHour! > 21 {
            print ("show popup")
            self.TimePopupAlert()
        } else {
            print ("do nothing")
           
        }
    }
    @objc func TimePopupAlert(){
        let alertController = UIAlertController (title: "Curfew Notice", message: "You can use this app only 7am to 10pm", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.exitApp()
        }))
        //alertController.addAction(firstAction)

        let alertWindow = UIWindow(frame: UIScreen.main.bounds)

        alertWindow.rootViewController = UIViewController()
       alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()

        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)

    }

    func exitApp() {
           exit(0)
    }

}


