//
//  UploadProfilePictureViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 19/04/21.
//

import UIKit

class UploadProfilePictureViewController: ServiceBaseViewController {

    // MARK: - Outlets

    // MARK: - Properties

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = AppString.UPLOAD_YOUR_PROFILE_PIC
        stepLabel.text = "5/6"
    }

    // MARK: - Layout

    // MARK: - User Interaction

    @IBAction func uploadSelfieButtonAction(_ sender: Any) {
        navigate(.uploadIDProof)
    }
    
    // MARK: - Additional Helpers

}

