//
//  BabyAboutCollectionViewController.swift
//  ChildAbout
//
//  Created by Disha Sharma on 18/12/24.
//

import UIKit

//private let reuseIdentifier = "Cell"
private let headingReuseIdentifier = "Heading"

class BabyAboutCollectionViewController: UICollectionViewController {
    
    struct AltrackStatic {
        var name : String
    }
    
    var selectedChildID: Int = 1
    
    init?(selectedChildID: Int, coder: NSCoder) {
        self.selectedChildID = selectedChildID
        print(selectedChildID)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headingReuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        if section == 1 { return 3 }
        if section == 2 { return 1 }
        if section == 3 {
            if let count = FamilyManager.shared.getChildDetails(byID: selectedChildID)?.history.count {
                if count > 4 {
                    return 4
                } else {
                    return count
                }
            } else {
                return 0
            }
        }
        else { return 0 }
            
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(indexPath.section) {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "baby", for: indexPath) as! BabyCardCollectionViewCell
        
            let cellData = FamilyManager.shared.getChildDetails(byID: selectedChildID)
            cell.kidPhoto.layer.cornerRadius = cell.kidPhoto.frame.size.width / 2
            cell.clipsToBounds = true
            cell.kidPhoto.image = convertDataToImage(data: cellData?.photo)
            cell.labelOutlet.text = "\(cellData?.firstName ?? "") \(cellData?.lastName ?? "")"
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Detail", for: indexPath) as! DetailCollectionViewCell
            
            let cellData = FamilyManager.shared.getChildDetails(byID: selectedChildID)
            switch indexPath.item{
            case 0:
                cell.data.text = "Month"
                cell.heading.text = "\(cellData?.age ?? 1)"
            case 1:
                cell.data.text = "Height (cm)"
                cell.heading.text = "\(cellData?.height ?? 1)"
            case 2:
                cell.data.text = "kg"
                cell.heading.text = "\(cellData?.weight ?? 1)"
            default:
                return UICollectionViewCell()
            }
            
            cell.layer.cornerRadius=14
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "alTrack", for: indexPath) as! ALTrackCollectionViewCell
            
            cell.name.text = "AL-Track"
            cell.layer.cornerRadius = 14
            cell.layer.borderWidth = 0.5
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "search", for: indexPath) as! SearchCollectionViewCell
            
            let cellData = FamilyManager.shared.getChildDetails(byID: selectedChildID)?.history[indexPath.item]
            cell.name.text = cellData?.condition
            cell.remedy.text = "Remedy Suggested : \(cellData?.selectedRemedy.title ?? "")"
            if let date = cellData?.date {
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
            cell.layer.cornerRadius = 14
            cell.layer.borderWidth = 0.5
            
            return cell
        default:
            return UICollectionViewCell()
        }
//
    }
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section : NSCollectionLayoutSection
            
            switch sectionIndex {
            case 0:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .absolute(90))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 18, trailing: 12)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case 3:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 18, trailing: 17)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            default:
                return nil
            }
            if sectionIndex == 3 {
                let headingSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let heading = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headingSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                heading.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0)
                
                section.boundarySupplementaryItems = [heading]
            }
            return section
           
            
        }
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let heading = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headingReuseIdentifier, for: indexPath)
        heading.subviews.forEach {$0.removeFromSuperview()}
        let label = UILabel(frame: heading.bounds)
       
        label.text = "History"
        
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        heading.addSubview(label)
        return heading
    }
    // Add this property to store the selected history record
    var selectedHistoryRecord: HistoryRecord?
//    var selectedTimeDate : Date?
    // Detect cell selection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if let record = FamilyManager.shared.getChildDetails(byID: selectedChildID)?.history[indexPath.item] {
                selectedHistoryRecord = record
//                selectedTimeDate = record.
//                print(selectedHistoryRecord)
                performSegue(withIdentifier: "babyHistorySegue", sender: self)
            }
        }
    }


    // Update the IBAction to pass the selectedHistoryRecord
   

    
    @IBAction func unwindToBabyAbout(_ unwindSegue: UIStoryboardSegue) {
        collectionView.reloadData()
    }
    
    @IBAction func unwindToEditedBabyAbout(_ unwindSegue: UIStoryboardSegue) {
        collectionView.reloadSections(IndexSet(integersIn: 0..<2))
    }
    
    @IBSegueAction func aboutToBabyDetails(_ coder: NSCoder, sender: Any?) -> JackTableViewController? {
        return JackTableViewController(coder: coder, childId: selectedChildID)
    }
    
    @IBSegueAction func babyAboutToAlTrack(_ coder: NSCoder) -> AlTrackTableViewController? {
        return AlTrackTableViewController(coder: coder, selectedChildId: selectedChildID)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "babyHistorySegue"{
            let destinationVC = segue.destination as? History
            destinationVC?.data = selectedHistoryRecord
//            destinationVC?.recordDateTime =
        }
//           let destinationVC = segue.destination as? History,
//        destinationVC.data = selectedHistoryRecord
//           let historyRecord = selectedHistoryRecord {
//            destinationVC.data = historyRecord
//        }
    }
//    @IBSegueAction func babyHistory(_ coder: NSCoder, sender: Any?) -> History? {
//        print(selectedHistoryRecord!)
//        guard let historyRecord = selectedHistoryRecord else { return History(coder: coder) }
//           return History(coder: coder, data: historyRecord)
//    }
    
}
