//
//  ServiceBaseViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 18/04/21.
//

import UIKit

class ServiceBaseViewController: BaseViewController {

    // MARK: - Outlets

    // MARK: - Properties

    lazy var stepLabel: UILabel = {
        var label = UILabel()
        label.font = AppFont.font(style: .medium, size: 13)
        label.textColor = AppColor.primaryLabelColor
        return label
    }()

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stepLabel)
    }

    // MARK: - Layout

    // MARK: - User Interaction

    // MARK: - Additional Helpers

}
