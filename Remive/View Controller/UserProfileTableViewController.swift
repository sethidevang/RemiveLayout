//
//  UserProfileTableViewController.swift
//  Remive
//
//  Created by Devang IOS on 14/01/25.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var mail: UILabel!
    
    @IBOutlet weak var address: UITextField!
    
    
    var userParent = FamilyManager.shared.getParentDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.layer.cornerRadius = image.frame.size.width / 2
        firstName.text = userParent.firstName
        lastName.text = userParent.lastName
        image.image = convertDataToImage(data: userParent.image)
        phoneNumber.text = "\(userParent.phoneNumber)"
        mail.text = userParent.email
        address.text = userParent.address
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    @IBAction func changeAddress(_ sender: UITextField) {
//        userParent.address = sender.text
//    }
    
    @IBAction func changeAddress(_ sender: UITextField) {
//        userParent.address = sender.text
        var newParentDetail : ParentDetail = userParent
        newParentDetail.address = sender.text
        FamilyManager.shared.updateParentDetails(details: newParentDetail)
        
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
