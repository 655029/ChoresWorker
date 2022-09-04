
//
//  facebookLogin_delegate.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class facebookLogin_delegate: NSObject {
    
    private var delegate_socialLogin: socialLogin_Delegate?
    private var newViewController: UIViewController!
    var loginManager = LoginManager()
    init(delegate: socialLogin_Delegate, viewController: UIViewController) {
        super.init()
        self.delegate_socialLogin = delegate
        self.newViewController = viewController
        loginManager.logOut()
        Login_ButtonPressed()
    }
    
    func Login_ButtonPressed() {
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: self.newViewController) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    self.newViewController.hideActivity()
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        
        if((AccessToken.current) != nil){
            
            let id_Token = AccessToken.current!.tokenString
            
            let credential = FacebookAuthProvider.credential(withAccessToken: id_Token)
            
            Auth.auth().signIn(with: credential, completion: { (authResult, error) in
                if error != nil {
                    self.newViewController.hideActivity()
                    return
                }
                
                let currentUser = Auth.auth().currentUser
                let name = currentUser?.displayName ?? ""
                let email = currentUser?.email ?? ""
                let phoneNumber = currentUser?.phoneNumber ?? ""
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        return
                    }
                    let device_Id = UIDevice.current.identifierForVendor!.uuidString
                    self.delegate_socialLogin?.social_login(email: email, type: .facebook, token: idToken ?? "", deviceType: name, deviceId: device_Id, phoneNumber: phoneNumber)
                }
                
            })
        }
    }
}
extension facebookLogin_delegate: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        self.newViewController.hideActivity()
        print("result")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        self.newViewController.hideActivity()
        print("result")
    }
}
