//
//  ServiceCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/04/21.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                isSelectButton.setImage(UIImage(named: "COMPLETED JOB 1"), for: .normal)
            }
            
            else {
                isSelectButton.setImage(UIImage(named: ""), for: .normal)

            }
        }

    }

    // MARK: - Outlets

    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var isSelectedImageView: UIImageView!
    @IBOutlet weak var isSelectButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    // MARK: - Additional Helper Functions

    func configure(with service: Service) {
        serviceImageView.image = service.image
        serviceTitleLabel.text = service.title
    }
    
}
