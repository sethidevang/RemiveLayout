//
//  JackTableViewController.swift
//  Remive
//
//  Created by Disha Sharma on 06/12/24.
//

import UIKit

class JackTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var imageOutlet: UIImageView!
    
    @IBOutlet var dobDatePicker: UIDatePicker!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var weight: UITextField!
    
    @IBOutlet weak var height: UITextField!
    
    @IBOutlet weak var allergyCount: UILabel!
    var selectedChildID: Int
    
    @IBOutlet weak var genderText: UIButton!
    
    
//    cell.kidPhoto.layer.cornerRadius = cell.kidPhoto.frame.size.width / 2
//    cell.clipsToBounds = true
//    cell.kidPhoto.image = cellData?.photo
//    cell.labelOutlet.text = "\(cellData?.firstName ?? "") \(cellData?.lastName ?? "")"
//    
    init?(coder: NSCoder, childId: Int) {
        selectedChildID = childId
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellData = FamilyManager.shared.getChildDetails(byID: selectedChildID)
        imageOutlet.layer.cornerRadius = imageOutlet.frame.size.width / 2
        imageOutlet.image = cellData?.photo
        firstName.text = cellData?.firstName
        lastName.text = cellData?.lastName
        weight.text = "\(cellData?.weight ?? 1)"
        height.text = "\(cellData?.height ?? 0)"
        allergyCount.text = "\(cellData?.alTrack.count ?? 0)"
//        genderText.titleLabel?.text = cellData?.gender
        genderText.setTitle(cellData?.gender, for: .normal)
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
//        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in print("User has choosen camera")
                imagePicker.sourceType = .camera
                self.present(imagePicker,animated: true , completion: nil)
            })
            alertController.addAction(cameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in print("User has choosen photo library")
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker,animated: true , completion: nil)
            })
            
            alertController.addAction(photoLibraryAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imageOutlet.image = selectedImage
        imageOutlet.layer.cornerRadius = imageOutlet.frame.size.width / 2
        imageOutlet.clipsToBounds = true
        imageOutlet.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
