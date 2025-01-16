//
//  EditAlTrackTableViewController.swift
//  Remive
//
//  Created by Dakshdeep Singh - University on 16/01/25.
//

import UIKit

class EditAlTrackTableViewController: UITableViewController {
    
    let selectedChildId: Int
    let allAllergies: [AllergyCategory] = FamilyManager.shared.getAllAllergies()
    var selectedAllergies: [AllergyCategory] = []
    
    init?(selectedChildId: Int, coder: NSCoder) {
        self.selectedChildId = selectedChildId
        selectedAllergies = FamilyManager.shared.getAllergies(ofChildID: selectedChildId)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 10/255, blue: 84/255, alpha: 1.0)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAllergies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alTrackCell", for: indexPath)

        cell.textLabel?.text = allAllergies[indexPath.row].rawValue
        
        if selectedAllergies.contains(where: { $0.rawValue == allAllergies[indexPath.row].rawValue }) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            selectedAllergies.removeAll(where: { $0.rawValue == allAllergies[indexPath.row].rawValue })
            FamilyManager.shared.removeAllergy(fromChildID: selectedChildId, allergy: allAllergies[indexPath.row])
        } else {
            cell.accessoryType = .checkmark
            selectedAllergies.append(allAllergies[indexPath.row])
            FamilyManager.shared.addAllergy(toChildID: selectedChildId, allergy: allAllergies[indexPath.row])
        }
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
