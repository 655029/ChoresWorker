//
//  HomeBaseViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit
import SideMenu

class HomeBaseViewController: BaseViewController {
    
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationItem.title = "Hello \(UserStoreSingleton.shared.name ?? "")"
        updateMenus()
        setupSideMenu()
        setNavbarRightButton()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    // MARK: - Additional Helpers
    
    
    private func makeSettings() -> SideMenuSettings {
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
    }
    
    func setNavbarRightButton() {
        let barButton = UIBarButtonItem(image: UIImage(named: "menu.iocn"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(rightBarButton))
        barButton.tintColor = .white
        navigationItem.rightBarButtonItems = [barButton]
    }
    
    @objc private func rightBarButton(_ sender: UIBarItem) {
        if let viewController = SideMenuManager.default.rightMenuNavigationController {
            //viewController.delegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
}






