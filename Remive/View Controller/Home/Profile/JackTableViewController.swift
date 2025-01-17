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
    @IBOutlet weak var genderText: UIButton!
    
    var selectedChildID: Int
   
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
        dobDatePicker.date = cellData?.dob ?? .now
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        var newChildDetail = FamilyManager.shared.getChildDetails(byID: selectedChildID)
        
        newChildDetail?.firstName = firstName.text!
        newChildDetail?.lastName=lastName.text
        newChildDetail?.dob=dobDatePicker.date
        newChildDetail?.weight=Double(weight.text ?? "")
        newChildDetail?.height=Double(height.text ?? "")
        newChildDetail?.photo=imageOutlet.image
        
        FamilyManager.shared.updateChildDetails(byID: selectedChildID, with: newChildDetail!)
        
        performSegue(withIdentifier: "unwindToUpdatedBabyAbout", sender: self)
    }
    
    
}
