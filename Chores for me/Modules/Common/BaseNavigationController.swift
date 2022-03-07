//
//  BaseNavigationController.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        transparentNavigationBar()
    }

    // MARK: - Layout

    func darkNavigationBar() {
        if #available(iOS 13.0, *) {

            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 25)]
            navBarAppearance.titleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 18)]
            navBarAppearance.backgroundColor = AppColor.secondaryBackgroundColor

            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance

        } else {

            navigationBar.largeTitleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 25)]
            navigationBar.titleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 18)]
            navigationBar.backgroundColor = AppColor.secondaryBackgroundColor
        }

        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()

        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.barTintColor = AppColor.secondaryBackgroundColor

    }

    func transparentNavigationBar() {
        if #available(iOS 13.0, *) {

            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 25)]
            navBarAppearance.titleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 21)]
            navBarAppearance.backgroundColor = .clear

            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance

        } else {

            navigationBar.largeTitleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 25)]
            navigationBar.titleTextAttributes = [.foregroundColor: AppColor.primaryLabelColor, .font: AppFont.font(style: .bold, size: 21)]
            navigationBar.backgroundColor = .clear
        }

        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()

        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.barTintColor = AppColor.primaryBackgroundColor

    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
