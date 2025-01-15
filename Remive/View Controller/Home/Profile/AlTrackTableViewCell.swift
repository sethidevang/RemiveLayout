//
//  AlTrackTableViewCell.swift
//  Remive
//
//  Created by Disha Sharma on 01/12/24.
//

import UIKit

class AlTrackTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var subtitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(allergy: Allergy) {
        titleLabel.text = allergy.title
        subtitleLabel.text = allergy.subtitle
    }
}
