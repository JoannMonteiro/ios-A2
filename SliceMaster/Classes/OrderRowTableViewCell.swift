//
//  OrderRowTableViewCell.swift
//  SliceMaster
//
//  Created by Joann Monteiro on 2026-07-16.
//

import UIKit

class OrderRowTableViewCell: UITableViewCell {

    // hook up in storyboard prototype cell
        @IBOutlet var imgAvatar: UIImageView!
        @IBOutlet var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
