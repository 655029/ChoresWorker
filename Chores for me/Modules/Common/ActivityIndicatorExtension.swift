//
//  ActivityIndicatorExtension.swift
//  Chores for me
//
//  Created by Bright_1 on 14/09/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Toast_Swift
extension UIViewController {
    func showActivity() {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30), type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "AppColor"))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func showMessage(_ withMessage : String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.cornerRadius = 5.0
        style.backgroundColor = .black
        style.messageFont = UIFont.boldSystemFont(ofSize: 15.0)
        DispatchQueue.main.async {
            self.view.clearToastQueue()
            self.view.makeToast(withMessage, duration: 2.0, position: .top, style: style)
        }
       
    }
}
