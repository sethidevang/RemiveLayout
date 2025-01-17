//
//  SavedInsightTableViewController.swift
//  Remive
//
//  Created by Dakshdeep Singh - University on 14/01/25.
//

import UIKit

protocol SavedInsightsDelegate: AnyObject {
    func didClearSavedInsights()
}

class SavedInsightTableViewController: UITableViewController {
    
    weak var delegate: SavedInsightsDelegate?
    
    var savedInsights: [Insights] = []
    var deletedInsight: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = navigationItem.rightBarButtonItem?.tintColor
        
        savedInsights = InsightData.shared.getSavedInsights()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        savedInsights.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedInsightCell", for: indexPath) as! SavedInsightTableViewCell

        cell.headingLabel.text = savedInsights[indexPath.section].headingOne
        cell.bodyLabel.text = savedInsights[indexPath.section].headingTwo
        if let date = savedInsights[indexPath.section].savedDateTime {
            // Calculate the difference in days from the current date
            let calendar = Calendar.current
            let currentDate = Date()
            let components = calendar.dateComponents([.day], from: date, to: currentDate)
            
            if let daysAgo = components.day, daysAgo >= 0 {
                if daysAgo == 0 {
                    cell.dayTimeLabel.text = "Today"
                } else if daysAgo == 1 {
                    cell.dayTimeLabel.text = "Yesterday"
                } else {
                    cell.dayTimeLabel.text = "\(daysAgo) days ago"
                }
            } else {
                cell.dayTimeLabel.text = "Date not valid"
            }
        } else {
            cell.dayTimeLabel.text = "Date not added"
        }
        cell.imageOutlet.image = savedInsights[indexPath.section].image ?? UIImage(named: "defaultInsightImage")
        cell.imageOutlet.layer.cornerRadius = 10
        cell.imageOutlet.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 20
        cell.tag = indexPath.section

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let insightToRemove = savedInsights[indexPath.section]
            InsightData.shared.removeInsight(id: insightToRemove.id)
            savedInsights.remove(at: indexPath.section)
            deletedInsight = true
            
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
            delegate?.didClearSavedInsights()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindToSavedInsight(_ unwindSegue: UIStoryboardSegue) {
    }

    @IBAction func clearAllSavedInsightsButtonPressed(_ sender: UIBarButtonItem) {
        InsightData.shared.removeAllInsights()
        savedInsights.removeAll()
        deletedInsight = true
        tableView.reloadData()
        
        delegate?.didClearSavedInsights()
    }
    
    @IBSegueAction func savedInsightToShowInsight(_ coder: NSCoder, sender: Any?) -> DetailTableViewController? {
        if let sender = sender as? SavedInsightTableViewCell {
            return DetailTableViewController(coder: coder, data: savedInsights[sender.tag], heading1: InsightData.shared.getHeading(byId: savedInsights[sender.tag].id) ?? "Heading", isSaved: true)
        }
        return nil
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
