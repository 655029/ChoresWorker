//
//  MainTabBarViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        UITabBar.appearance().barTintColor = .black
        let firstVc = Storyboard.Home.viewController(for: HomeViewController.self)
        firstVc.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(named: "home"), tag: 0)
        let firstNavVc = BaseNavigationController(rootViewController: firstVc)

        let secondVc = Storyboard.Booking.viewController(for: BookingsViewController.self)
        secondVc.tabBarItem = UITabBarItem(title: "BOOKING", image: UIImage(named: "booking.tab.icon"), tag: 0)
        let secondNavVc = BaseNavigationController(rootViewController: secondVc)
        
        let thirdVc = Storyboard.Booking.viewController(for: BookingHistoryViewController.self)
        thirdVc.tabBarItem = UITabBarItem(title: "HISTORY", image: UIImage(named: "history.tab"), tag: 0)
        let thirdNavVc = BaseNavigationController(rootViewController: thirdVc)
        
        viewControllers = [firstNavVc, secondNavVc, thirdNavVc]
        

        // updateMenus()
        // setupSideMenu()
        //  addGesture(navigationController: firstNavVc, view: firstVc.view)
        //  addGesture(navigationController: secondNavVc, view: secondVc.view)
        // addGesture(navigationController: thirdNavVc, view: thirdNavVc.view)
    }

        }

   
   /* private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = .systemGray
        presentationStyle.menuStartAlpha = CGFloat(1.0)
        presentationStyle.menuScaleFactor = CGFloat(1.0)
        presentationStyle.onTopShadowOpacity = 0.0
        presentationStyle.presentingEndAlpha = CGFloat(0.5)
        presentationStyle.presentingScaleFactor = CGFloat(1.0)

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height)
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 1

        settings.allowPushOfSameClassTwice = false

        return settings
    }
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return modes[0]
    }
   
    private func setupSideMenu() {
        // Define the menus
        let nav = SideMenuNavigationController(rootViewController: Storyboard.Menu.viewController(for: SideMenuViewController.self))
        nav.navigationBar.isHidden = true
        SideMenuManager.default.rightMenuNavigationController = nav
    }
    
    private func addGesture(navigationController: UINavigationController, view: UIView) {
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
   
    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }*/


