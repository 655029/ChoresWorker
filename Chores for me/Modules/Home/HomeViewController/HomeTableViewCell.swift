//
//  HomeTableViewCell.swift
//  Chores for me
//  Created by Bright_1 on 17/09/21.
//

import UIKit


class HomeTableViewCell: UITableViewCell {

    
    // MARK: - Outlets
    @IBOutlet var time40Label: UILabel!
    @IBOutlet var serviceLabel1: UILabel!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet var dateLabel1: UILabel!
    @IBOutlet var profileImageView1: UIImageView!
    @IBOutlet var timeLabel1: UILabel!
    @IBOutlet var nameLabel1: UILabel!
    @IBOutlet var locationLabel1: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var serviceImageView1: UIImageView!
    @IBOutlet var lbl_createTime: UILabel!
    @IBOutlet var view_Rating: FloatRatingView!
    @IBOutlet weak var copybtn: UIButton!
    
    
    // MARK: - Propeties
    var homeArrSubCategory = [SubcategoryId]()

    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView1.register(UINib(nibName: "HomeCollectionviewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionviewCellCollectionViewCell")
        if let flowLayout = collectionView1?.collectionViewLayout as? UICollectionViewFlowLayout {
                      flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                   }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}


// MARK: - UICollectionViewDelegate
extension HomeTableViewCell: UICollectionViewDelegate {
    
}


// MARK: - UICollectionViewDataSource
extension HomeTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeArrSubCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionviewCellCollectionViewCell", for: indexPath) as? HomeCollectionviewCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.subcatgeoryLabel1.text = homeArrSubCategory[indexPath.row].name
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
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

