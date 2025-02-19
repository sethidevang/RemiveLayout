//
//  TableViewController.swift
//  vanshika
//
//  Created by Vanshika iOS on 10/12/24.
//

import UIKit

class ProfileTableViewController: UITableViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet var collection: UICollectionView!
    
    var userDetail = FamilyManager.shared.getParentDetails()
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section : NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 0)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.collectionViewLayout = createLayout()
        ParentDetail()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func ParentDetail(){
        userName.text = "\(userDetail.firstName)" + " " + "\(userDetail.lastName ?? "Dummy")"
        userImage.image = convertDataToImage(data: userDetail.image)
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FamilyManager.shared.getChildCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Profile", for: indexPath) as! ProfileIconCollectionViewCell
        
        
        //to add the add child option on the profile page... uncomment this
        
//        if indexPath.item == FamilyManager.shared.getChildCount() {
//            cell.photo.image = UIImage(named: "add")
//            cell.photo.layer.cornerRadius = cell.photo.frame.size.width / 2
//            cell.clipsToBounds = true
//            cell.name.text = "Add Child"
//        } else {
        
            if let cellData = FamilyManager.shared.getChildDetails(byIndex: indexPath.item) {
                cell.photo.layer.cornerRadius = cell.photo.frame.size.width / 2
                cell.photo.image = convertDataToImage(data: cellData.photo)
                cell.photo.clipsToBounds = true
                cell.photo.contentMode = .scaleAspectFill
                let firstName = cellData.firstName
//                let lastName = cellData.lastName ?? ""
                cell.name.text = "\(firstName)"
                cell.kidId = cellData.id
            } else {
                cell.photo.image = UIImage(systemName: "person.circle")
                cell.photo.layer.cornerRadius = cell.photo.frame.width / 2
                cell.clipsToBounds = true
                cell.photo.backgroundColor = UIColor(red: 242, green: 134, blue: 155, alpha: 1)
                cell.name.text = "No Name"
            }
        //for childAdd Option
//        }
    
        return cell
    }
    
    @IBAction func unwindToGoBack(_ unwindSegue: UIStoryboardSegue) {
        tableView.reloadData()
        collection.reloadData()
    }
    
    @IBSegueAction func profileToBabyAbout(_ coder: NSCoder, sender: Any?) -> BabyAboutCollectionViewController? {
        if let cell = sender as? ProfileIconCollectionViewCell {
            return BabyAboutCollectionViewController(selectedChildID: cell.kidId, coder: coder)
        }
        return nil
    }
    
}
