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
    let selectedIndexPath: IndexPath?
    let isSaved: Bool
    
    init?(coder: NSCoder, data: Insights?, heading1: String?, isSaved: Bool) {
        self.data = data
        self.heading1 = heading1
        selectedIndexPath = nil
        self.isSaved = isSaved
        super.init(coder: coder)
    }

    init?(coder: NSCoder, data: Insights?, heading1: String?, indexPath: IndexPath?, isSaved: Bool) {
        self.data = data
        self.heading1 = heading1
        self.selectedIndexPath = indexPath
        self.isSaved = isSaved
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSaved {
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
        }

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
    
    @IBAction func bookMark(_ sender: UIBarButtonItem) {
        if let currentImage = navigationItem.leftBarButtonItem?.image {
            if currentImage == UIImage(systemName: "bookmark") {
                navigationItem.leftBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
                InsightData.shared.saveInsight(id: data?.id ?? -1)
            } else if currentImage == UIImage(systemName: "bookmark.fill") {
                navigationItem.leftBarButtonItem?.image = UIImage(systemName: "bookmark")
                InsightData.shared.removeInsight(id: data?.id ?? -1)
            }
        }
    }
    
}
