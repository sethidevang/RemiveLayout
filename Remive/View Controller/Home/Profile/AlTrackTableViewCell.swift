//
//  AlTrackTableViewCell.swift
//  Remive
//
//  Created by Disha Sharma on 01/12/24.
//

import UIKit

class AlTrackTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(allergy:String) {
        titleLabel.text = allergy
//       
    }
}
