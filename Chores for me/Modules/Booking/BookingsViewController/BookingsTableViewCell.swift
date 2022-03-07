//
//  BookingsTableViewCell.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit

class BookingsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var lbl_price: UILabel!
    @IBOutlet var serviceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var serviceImageView: UIImageView!
    @IBOutlet var lbl_40m: UILabel!
    @IBOutlet weak var copybtn: UIButton!
    
    @IBOutlet var view_Rating: FloatRatingView!
    
    var arrSubCategory = [SubcategoryId]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Additional Helper Functios
}

// MARK: - UICollectionViewDelegate

extension BookingsTableViewCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension BookingsTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingRequestServiceCollectionViewCell", for: indexPath) as? BookingRequestServiceCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.subcatgeoryLabel.text = arrSubCategory[indexPath.row].name
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BookingsTableViewCell: UICollectionViewDelegateFlowLayout {
    
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
