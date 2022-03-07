//
//  AlertControllerFile.swift
//  CoreDataTask
//
//  Created by Bright Roots on 02/08/21.
//

import Foundation
import UIKit
extension UIViewController{
    public func openAlert(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }


public func showPermissionAlert(){
    let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
}
}
