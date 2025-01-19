//
//  CureTipTableViewCell.swift
//  cureAsk1
//
//  Created by Devang IOS on 18/12/24.
//

import UIKit

class CureTipTableViewCell: UITableViewCell {
    @IBOutlet weak var tablePhoto: UIImageView!
    
    @IBOutlet weak var tableStep: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func updateUI(rem : Remedy){
//        tablePhoto.image = rem.images
//        tableStep.text=rem.steps
//    }
    func updateUI(rem: Remedy) {
        // Assuming rem.images contains image names or URLs as strings
        if let firstImageName = rem.images.first, let image = UIImage(named: firstImageName) {
            tablePhoto.image = image
        }
        tableStep.text = rem.steps.joined(separator: "\n") // Joining steps as a readable string
    }

}
