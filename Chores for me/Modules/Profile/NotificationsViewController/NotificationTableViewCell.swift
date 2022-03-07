//
//  NotificationTableViewCell.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Notification: UILabel!
    @IBOutlet weak var lbl_TimeAgo: UILabel!
    @IBOutlet weak var btn_Rate: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
