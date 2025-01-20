//
//  HomeCollectionViewController.swift
//  Remive
//
//  Created by Devang IOS on 09/12/24.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headingReuseIdentifier = "Heading"

class HomeCollectionViewController: UICollectionViewController {
    
    var selectedChildIndex = 0
    var selectedChildIndexPath: IndexPath = IndexPath()
    var selectedChildId: Int = 1
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section : NSCollectionLayoutSection
            
            switch sectionIndex {
            case 0:
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(120))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .groupPaging
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(120))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
               
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 17, bottom: 0, trailing: 17)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 18, trailing: 17)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)

            case 3:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(115))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 18, trailing: 17)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(115))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)

            default:
                return nil
            }
            
            let headingSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let heading = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headingSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            heading.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0)
            
            section.boundarySupplementaryItems = [heading]
            return section
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headingReuseIdentifier)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return FamilyManager.shared.getChildCount() + 1
        case 1:
            return 1
        case 2:
            if let count = FamilyManager.shared.getChildDetails(byIndex: selectedChildIndex)?.history.count {
                if count > 4 {
                    return 4
                } else {
                    return count
                }
            } else {
                return 0
            }
        case 3:
            return 2
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "baby", for: indexPath) as! BabyCardCollectionViewCell
            
            if indexPath.item == FamilyManager.shared.getChildCount() {
                cell.kidPhoto.image = UIImage(named: "add")
                cell.kidPhoto.layer.cornerRadius = cell.kidPhoto.frame.size.width / 2
                cell.clipsToBounds = true
                cell.labelOutlet.text = "Add Child"
            } else {
                if let cellData = FamilyManager.shared.getChildDetails(byIndex: indexPath.item) {
                    cell.kidPhoto.layer.cornerRadius = cell.kidPhoto.frame.size.width / 2
                    cell.clipsToBounds = true
                    cell.kidPhoto.contentMode = .scaleAspectFill
                    cell.kidPhoto.image = convertDataToImage(data: cellData.photo)
                    let firstName = cellData.firstName
                    let lastName = cellData.lastName ?? ""
                    cell.labelOutlet.text = "\(firstName) \(lastName)"
                    cell.kidId = cellData.id
                } else {
                    cell.kidPhoto.image = UIImage(systemName: "person.circle")
                    cell.kidPhoto.layer.cornerRadius = cell.kidPhoto.frame.width / 2
                    cell.clipsToBounds = true
                    cell.kidPhoto.backgroundColor = UIColor(red: 242, green: 134, blue: 155, alpha: 1)
                    cell.labelOutlet.text = "No Name"
                }
            }
            
            if selectedChildIndex == indexPath.item {
                cell.kidPhoto.layer.borderWidth = 3
                cell.kidPhoto.layer.borderColor = CGColor(red: 0.941, green: 0.039, blue: 0.329, alpha: 1.0)
                selectedChildIndexPath = indexPath
            }

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cureAsk", for: indexPath) as! CureAskCollectionViewCell
            
            cell.firstAid.text = "Cure Ask"
            cell.symbol.image = UIImage(systemName: "cross.case")!
            cell.nextSymbol.image = UIImage(systemName: "chevron.right")!

            cell.layer.borderWidth = 1.0
//            cell.layer.borderColor = CGColor(red: 0.941, green: 0.039, blue: 0.329, alpha: 1.0)
            if traitCollection.userInterfaceStyle == .dark {
                cell.layer.borderColor = CGColor(red: 0.941, green: 0.039, blue: 0.329, alpha: 1.0)
                
            }
            cell.layer.cornerRadius = 14
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "search", for: indexPath) as! SearchCollectionViewCell
        
            let cellData = FamilyManager.shared.getChildDetails(byIndex: selectedChildIndex)?.history[indexPath.item]
            cell.name.text = cellData?.condition
            cell.remedy.text = ("Remedy Suggested : \(cellData?.selectedRemedy.title ?? "")")
            if let date = cellData?.date {
                // Calculate the difference in days from the current date
                let calendar = Calendar.current
                let currentDate = Date()
                
                let components = calendar.dateComponents([.day], from: date, to: currentDate)
                
                if let daysAgo = components.day, daysAgo >= 0 {
                    // Set the formatted text: "x days ago"
                    if daysAgo == 0 {
                        cell.time.text = "Today"
                    } else if daysAgo == 1 {
                        cell.time.text = "Yesterday"
                    } else {
                        cell.time.text = "\(daysAgo) days ago"
                    }
                } else {
                    cell.time.text = "Date not valid"
                }
            }
            cell.layer.borderWidth = 1
            if traitCollection.userInterfaceStyle == .dark {
                cell.layer.borderColor = CGColor(gray: 1.0, alpha: 1.0)  // White border for Dark Mode
            }
            cell.layer.cornerRadius = 14
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "insight", for: indexPath) as! InsightCollectionViewCell
        
            let cellData = InsightData.shared.getTwoRandomInsights()[0]
            cell.image.layer.cornerRadius = 14
            cell.image.contentMode = .scaleAspectFill
            cell.image.image = cellData.image
            cell.label1.text = cellData.headingOne
            cell.label2.text = cellData.headingTwo
            cell.layer.cornerRadius = 14
            cell.layer.borderWidth = 1
            cell.insight = cellData
            if traitCollection.userInterfaceStyle == .dark {
                cell.layer.borderColor = CGColor(gray: 1.0, alpha: 1.0)  // White border for Dark Mode
            }
            return cell
       
        default:
            return UICollectionViewCell()
        }
    }
    
    var selectedHistoryRecord: HistoryRecord?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item < FamilyManager.shared.getChildCount() {
            if let cell = collectionView.cellForItem(at: selectedChildIndexPath) as? BabyCardCollectionViewCell {
                cell.kidPhoto.layer.borderWidth = 0
            }
                
            if let cell = collectionView.cellForItem(at: indexPath) as? BabyCardCollectionViewCell {
                cell.kidPhoto.layer.borderWidth = 3
                cell.kidPhoto.layer.borderColor = CGColor(red: 0.941, green: 0.039, blue: 0.329, alpha: 1.0)
                selectedChildIndex = indexPath.item
                selectedChildIndexPath = indexPath
                selectedChildId = FamilyManager.shared.getChildDetails(byIndex: indexPath.item)!.id
            }
            collectionView.reloadSections(IndexSet(integer: 2))
        }
        else if indexPath.section==0 && indexPath.item >= FamilyManager.shared.getChildCount() {
            performSegue(withIdentifier: "homeToAddBaby", sender: self)
        }
        else if indexPath.section == 2{
            if let record = FamilyManager.shared.getChildDetails(byID: selectedChildId)?.history[indexPath.item] {
                selectedHistoryRecord = record
                performSegue(withIdentifier: "homeToHistory", sender: self)
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let heading = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headingReuseIdentifier, for: indexPath)
        heading.subviews.forEach {$0.removeFromSuperview()}
        let label = UILabel(frame: heading.bounds)
        switch indexPath.section {
        case 0:
            label.text = "My Kids"
        case 1:
            label.text = "Find an Aid"
        case 2:
            label.text = "Recent Search"
        case 3:
            label.text = "Recommended Insights"
        default:
            label.text = "none"
        }
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        heading.addSubview(label)
        return heading
    }
    
    @IBSegueAction func presentInsight(_ coder: NSCoder, sender: Any?) -> DetailTableViewController? {
        if let cell = sender as? InsightCollectionViewCell {
            var isSaved: Bool = false
            
            if InsightData.shared.getSavedInsights().contains(where: { $0.id == cell.insight?.id }) {
                isSaved = true
            }
            
            return DetailTableViewController(coder: coder, data: cell.insight, heading1: cell.insight?.headingOne, isSaved: isSaved)
        }

        return nil
    }
    
    @IBSegueAction func homeToCureAsk(_ coder: NSCoder) -> CureAskTableViewController? {
        return CureAskTableViewController(coder: coder, id: selectedChildId)
    }

    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        collectionView.reloadData()
    }
    
    @IBAction func unwindFromShowInsightToHome(_ unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func thumbsUp(_ sender: UIButton) {
//        let indexPath = IndexPath(item: <#T##Int#>, section: <#T##Int#>)
//        if let data = FamilyManager.shared.getChildDetails(byID: selectedChildId)?.history
//        if let record = FamilyManager.shared.getChildDetails(byID: selectedChildId)?.history[indexPath.item] {
//            selectedHistoryRecord = record
//            performSegue(withIdentifier: "homeToHistory", sender: self)
        
        if sender.currentImage == UIImage(systemName: "hand.thumbsup.fill") {
            sender.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToHistory"{
            let destinationVC = segue.destination as? History
            destinationVC?.data = selectedHistoryRecord
        }
    }
    
    // MARK: UICollectionViewDelegate

    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
