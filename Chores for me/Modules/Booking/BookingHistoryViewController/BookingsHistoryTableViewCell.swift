//
//  BookingsHistoryTableViewCell.swift
//  Chores for me
//
//  Created by Bright_1 on 16/09/21.
//

import UIKit
import Toast_Swift

class BookingsHistoryTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet var historySecviceLbl: UILabel!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet var bookingcollectionView: UICollectionView!
    @IBOutlet var historyDateLabel: UILabel!
    @IBOutlet var historyProfileImageView: UIImageView!
    @IBOutlet var historyTimeLabel: UILabel!
    @IBOutlet var historyNameLabel: UILabel!
    @IBOutlet var historyLocationLabel: UILabel!
    @IBOutlet var historyServiceImageView: UIImageView!
    
    @IBOutlet weak var historyCancelLabel: UILabel!
    @IBOutlet weak var historyCheckButton: UIButton!
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var copybtn: UIButton!
   
    @IBOutlet var view_Rating: FloatRatingView!
    
    var historyArrSubCategory = [SubcategoryId]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")
        
        historyCancelLabel.isHidden = true
        historyCheckButton.isHidden = true
        if let flowLayout = historyCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                      flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                   }
//        if let flowLayout = bookingcollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//                      flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//                   }
       // copybtn.addTarget(self, action: #selector(copy_btn_tapped), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
//    @objc func copy_btn_tapped(){
//        UIPasteboard.general.string = historyLocationLabel.text
//       // showMessage("Copid")
//        print("Button Tapped")
//
//        if let myString = UIPasteboard.general.string {
//            print(myString)
//        }
//    }
    // MARK: - Additional Helper Functios

    
}
// MARK: - UICollectionViewDelegate

extension BookingsHistoryTableViewCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension BookingsHistoryTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyArrSubCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingRequestServiceCollectionViewCell", for: indexPath) as? BookingRequestServiceCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.subcatgeoryLabel.text = historyArrSubCategory[indexPath.row].name
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BookingsHistoryTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}
