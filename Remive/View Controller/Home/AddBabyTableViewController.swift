//
//  AddBabyTableViewController.swift
//  Remive
//
//  Created by Dakshdeep Singh - University on 17/01/25.
//

import UIKit

class AddBabyTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var genderButtonOutlet: UIButton!
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var dob: UIDatePicker!
    
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        guard
                let firstName = firstnameTextField.text, !firstName.isEmpty,
                let lastName = lastnameTextField.text, !lastName.isEmpty,
                let weight = weightTextField.text, !weight.isEmpty,
                let height = heightTextField.text, !height.isEmpty,
                dob.date <= Date()
        else {
            saveButton.isEnabled = false
            return
        }
        
        saveButton.isEnabled = true
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard
                let firstName = firstnameTextField.text, !firstName.isEmpty,
                let lastName = lastnameTextField.text, !lastName.isEmpty,
                let weight = weightTextField.text, !weight.isEmpty,
                let height = heightTextField.text, !height.isEmpty,
                let gender = genderButtonOutlet.titleLabel?.text,
                dob.date <= Date()
        else {
            sender.isEnabled = false
            return
        }
        
        FamilyManager.shared.addChild(KidDetail(id: 0, photo: image.image, firstName: firstName, lastName: lastName, dob: dob.date, gender: gender, height: Double(height), weight: Double(weight), alTrack: [], history: []))

        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
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
        image.image = selectedImage
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func genderSelectAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let male = UIAlertAction(title: "Male", style: .default) { _ in
            sender.setTitle("Male", for: .normal)
            }
            
        let female = UIAlertAction(title: "Female", style: .default) { _ in
            sender.setTitle("Female", for: .normal)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(male)
        alertController.addAction(female)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

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
