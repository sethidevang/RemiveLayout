//
//  BabyCareDetailTableViewController.swift
//  Remive
//
//  Created by Disha Sharma on 09/12/24.
//

import UIKit

class DetailTableViewController: UITableViewController {
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var heading2: UILabel!
    
    @IBOutlet var bookmark: UIBarButtonItem!
    
    @IBOutlet var paraHeading1: UILabel!
    
    @IBOutlet var paragraph1: UILabel!
    
    @IBOutlet var paraHeading2: UILabel!
    
    @IBOutlet var paragraph2: UILabel!
    
        var data: Insights?
        var heading1: String?

        init?(coder: NSCoder, data: Insights?, heading1: String?) {
            self.data = data
            self.heading1 = heading1
            super.init(coder: coder)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            if let heading = heading1 {
                self.navigationItem.title = heading
            }

            if let dat = data {
                heading2.text = dat.headingTwo
                image.image = dat.image
                image.contentMode = .scaleAspectFill
                paragraph1.text = dat.dataOne
                paragraph2.text = dat.dataTwo
                paraHeading1.text = dat.subheadingOne
                paraHeading2.text = dat.subheadingTwo
            }
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)

            // Disable the default selection highlight effect by setting selectionStyle to .none
            cell.selectionStyle = .none

            return cell
        }

    var isBookmarked = false
    @IBAction func bookMark(_ sender: UIBarButtonItem) {
        if sender.image == UIImage(systemName: "bookmark.fill") {
                
            sender.image = UIImage(systemName: "bookmark")
            } else {
               
                sender.image = UIImage(systemName: "bookmark.fill")
            }
    }
    
}
