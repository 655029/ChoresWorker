//
//  CancelRequestTableViewCell.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit

class CancelRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var requestsLabelText: UILabel!
    @IBOutlet var checkButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
