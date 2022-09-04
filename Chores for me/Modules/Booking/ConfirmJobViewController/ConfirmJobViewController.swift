//
//  ConfirmJobViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 17/08/21.
//

import UIKit

class ConfirmJobViewController: UIViewController {


    // MARK: - Outlets
    @IBOutlet weak var servicesCollectioView: UICollectionView!
    @IBOutlet weak var progressStatusCollectioView: UICollectionView!

    // MARK: - Properties
    var arrayOfJobProgress: [String] = []


    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Job Status"

        servicesCollectioView.delegate = self
        servicesCollectioView.dataSource = self
        servicesCollectioView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")

        progressStatusCollectioView.delegate = self
        progressStatusCollectioView.dataSource = self
        progressStatusCollectioView.register(UINib(nibName: "JobStatusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JobStatusCollectionViewCell")
        arrayOfJobProgress.append("Job progress")
        arrayOfJobProgress.append("Accepted")
        arrayOfJobProgress.append("work started")
        arrayOfJobProgress.append("Completed")
    }

    // MARK: - Layout

    // MARK: - User Interaction

    @IBAction func tapCancellRequestButton(_ sender: Any) {
       // navigate(.cancelJobRequest(jobId: )
    }

    @IBAction func btn_SubmitCancelRequest(_ sender: UIButton) {
        
    }
    // MARK: - Additional Helpers
    
    
}

// MARK: - UICollectionViewDelegate

extension ConfirmJobViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension ConfirmJobViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == progressStatusCollectioView {
            return 4
        }
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == progressStatusCollectioView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobStatusCollectionViewCell", for: indexPath) as? JobStatusCollectionViewCell else {
                fatalError()
            }
            if indexPath.item == 0 {
                cell.leftBarView.isHidden = true
            }
            if indexPath.item == 3 {
                cell.rightBarView.isHidden = true
            }
            cell.jobProgressLabel.text = arrayOfJobProgress[indexPath.item]
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingRequestServiceCollectionViewCell", for: indexPath) as? BookingRequestServiceCollectionViewCell else {
            fatalError()
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConfirmJobViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == progressStatusCollectioView {
            return 0
        }
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == progressStatusCollectioView {
            return 0
        }
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == progressStatusCollectioView {
            return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
        }
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}

