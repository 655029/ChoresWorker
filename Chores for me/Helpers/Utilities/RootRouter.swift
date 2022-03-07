//
//  RootRouter.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit

class RootRouter {

    /** Replaces root view controller. You can specify the replacment animation type.
     If no animation type is specified, there is no animation */
    func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {
            print("No window in app")
            return
            //fatalError("No window in app")
        }
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.33, options: animationOptions, animations: {
            }, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }

    func loadMainAppStructure() {
        // Customize your app structure here
        let controller = BaseNavigationController(rootViewController: Storyboard.Authentication.viewController(for: LoginViewController.self))
        setRootViewController(controller: controller, animatedWithOptions: nil)
    }

    func loadProfileSetup() {
        // Customize your app structure here
        let controller = BaseNavigationController(rootViewController: Storyboard.Location.viewController(for: ChooseYourCityViewController.self))
        setRootViewController(controller: controller, animatedWithOptions: nil)
    }

    func loadMainHomeStructure() {
        // Customize your app structure here
        let controller = MainTabBarViewController()
        setRootViewController(controller: controller, animatedWithOptions: nil)
    }
}
