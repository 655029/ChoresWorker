////
////  CheckTIme.swift
////  Chores for me
////
////  Created by Bright Roots 2019 on 02/12/21.
////
//
//import Foundation
//import UIKit
//
//class CheckTimeViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
//
//let button = UIButton()
//let button2 = UIButton()
//extension UIViewController {
//
//    func CheckTimeFunc(){
//        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
//        let currentHour = componets.hour
//        if currentHour! < 7 || currentHour! > 21 {
//            print ("show popup")
//            self.TimePopupAlert()
//        } else {
//            print ("do nothing")
//            button.removeFromSuperview()
//            button2.removeFromSuperview()
//        }
//    }
//    @objc func TimePopupAlert(){
//        let alertController = UIAlertController (title: "Chores for Me", message: "you use this app only 7am to 10pm", preferredStyle: .alert)
//
//        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//            self.exitApp()
//        }))
//        //alertController.addAction(firstAction)
//
//        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//
//        alertWindow.rootViewController = UIViewController()
//       alertWindow.windowLevel = UIWindow.Level.alert + 1;
//        alertWindow.makeKeyAndVisible()
//
//        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
//
//    }
//
//    func exitApp() {
//           exit(0)
//    }
//
//    @objc func buttonAction(){
//        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
//        let currentHour = componets.hour
//        if currentHour! < 7 || currentHour! > 21 {
//            print ("show popup")
//            button.removeFromSuperview()
//            button2.removeFromSuperview()
//            self.TimePopupAlert()
//        } else {
//            print ("do nothing")
//            button.removeFromSuperview()
//            button2.removeFromSuperview()
//        }
//    }
//
//}
