//
//  JobStatusCollectionViewCell.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit

class JobStatusCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var jobProgressLabel: UILabel!
    @IBOutlet weak var jobProgressImageView: UIImageView!
    @IBOutlet weak var leftBarView: UIView!
    @IBOutlet weak var rightBarView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
