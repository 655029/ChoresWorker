
//
//  gmail_LoginDelegate.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.

import Foundation
import UIKit
import Firebase
import GoogleSignIn


class gmail_LoginDelegate:NSObject, GIDSignInDelegate {

    
    private var newViewController = UIViewController()
    private var delegate_socialLogin: socialLogin_Delegate?
    private let shared = GIDSignIn.sharedInstance()
    
    init(delegate: socialLogin_Delegate, viewController: UIViewController) {
        super.init()
        self.delegate_socialLogin = delegate
        self.newViewController = viewController
        GmailLoginInitialization()
        GmailLogin_ButtonClicked()
    }
    
    
    func GmailLoginInitialization(){
        shared?.presentingViewController = self.newViewController
        shared?.delegate = self
        
       // Loader.start(backColor: UIColor(white: 0, alpha: 0.6), baseColor: UIColor.white)
        
    }
    
    func GmailLogin_ButtonClicked(){
        shared?.signOut()
        shared?.signIn()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // Do whatever is required like stop animating once logged in.
    }
    
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if error != nil{
           // Loader.stop()
            print("Google Login Error",error.localizedDescription)
            return
        }
       
      
//        let user = UserModal(name: user.profile.name, photo: user.profile.imageURL(withDimension: 400).absoluteString, email: user.profile.email, dob: nil)
      
        let accessToken = user.authentication.accessToken!
        let id_Token = user.authentication.idToken
        
        let credential = GoogleAuthProvider.credential(withIDToken: id_Token!, accessToken: accessToken)
        print("credential for login is:",credential)
        Auth.auth().signIn(with: credential, completion: { (auth, error) in
            if let error = error {
                print("This is error::~ ",error)
                return
            }
            
            let currentUser = Auth.auth().currentUser
            let name = currentUser?.displayName ?? ""
            let email = currentUser?.email ?? ""
            let phoneNumber = currentUser?.phoneNumber ?? ""
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if error != nil {
                    self.newViewController.hideActivity()
                    return;
              }

              let device_Id = UIDevice.current.identifierForVendor!.uuidString
                self.delegate_socialLogin?.social_login(email: email, type: .google, token: idToken ?? "", deviceType: name, deviceId: device_Id, phoneNumber: phoneNumber)
            }
        })
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.newViewController.hideActivity()
        newViewController.present(viewController, animated: true, completion: nil)
    }
    
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.newViewController.hideActivity()
        newViewController.dismiss(animated: true, completion: nil)
    }
}
