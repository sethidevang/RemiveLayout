//
//  InsightsCollectionViewController.swift
//  Remive
//
//  Created by Disha Sharma on 07/12/24.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerReuseIdentifier = "Header"

class InsightsCollectionViewController: UICollectionViewController, SavedInsightsDelegate {
    
    func didClearSavedInsights() {
        collectionView.reloadData()
    }

    func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .fractionalHeight(0.315))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50))
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createCompositionalLayout()
    
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return InsightData.shared.getInsightCount()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InsightData.shared.getInsightItemCount(at: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = InsightData.shared.getInsight(section: indexPath.section, item: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BabyCare", for: indexPath) as! BabyCareCollectionViewCell
        
        cell.heading1.text = data.headingOne
        cell.heading2.text = data.headingTwo
        cell.image.image = data.image
        cell.image.layer.masksToBounds = true
        cell.image.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0.8
        cell.bookmarkButton.tag = data.id
        cell.shareButton.tag = data.id
        
        if InsightData.shared.getSavedInsights().contains(where: { $0.id == data.id }) {
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerReuseIdentifier,
            for: indexPath)
        
        header.subviews.forEach { $0.removeFromSuperview() }
 
 
        let label = UILabel(frame: header.bounds)
        label.frame = CGRect(x: 15, y: 0, width: header.bounds.width - 120, height: header.bounds.height)
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 23)
//            label.textColor = .black
        
        switch indexPath.section {
        case 0:
            label.text = "Baby Care"
        case 1:
            label.text = "Baby Diet"
        case 2:
            label.text = "Natural Remedies"
        default:
            label.text = ""
        }

        
        header.addSubview(label)
 
        
        return header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let savedInsightsVC = segue.destination as? SavedInsightTableViewController {
            savedInsightsVC.delegate = self
        }
    }
    
    @IBSegueAction func segue1(_ coder: NSCoder, sender: Any?) -> DetailTableViewController? {
        if let cell = sender as? UICollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell) {
            let data = InsightData.shared.getInsight(section: indexPath.section, item: indexPath.item)
            var isSaved: Bool = false
            
            if InsightData.shared.getSavedInsights().contains(where: { $0.id == data.id }) {
                isSaved = true
            }
            
            return DetailTableViewController(coder: coder, data: data, heading1: data.headingOne, indexPath: indexPath, isSaved: isSaved)
        }
    
        return nil
    }
    
    
//    @IBSegueAction func segue1(_ coder: NSCoder, sender: Any?) -> DetailTableViewController? {
//        if let cell = sender as? UICollectionViewCell,
//        let indexPath = collectionView.indexPath(for: cell) {
//            let data = InsightData.shared.getInsight(section: indexPath.section, item: indexPath.item)
//                return DetailTableViewController(coder: coder, data: data, heading1: data.headingOne)
//        }
//        
//        return nil
//    }
    
    @IBAction func showSavedInsightsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSavedInsights", sender: sender)
    }
    
    @IBAction func unwindTomain(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? DetailTableViewController,
           let indexPath = sourceVC.selectedIndexPath {
            collectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: indexPath.section)])
        }
        if let sourceVC = unwindSegue.source as? SavedInsightTableViewController {
            if sourceVC.deletedInsight == true {
                collectionView.reloadData()
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let insight = InsightData.shared.getInsightByIdFromAllInsights(sender.tag) else {
            print("No Insight found with the given ID.")
            return
        }
        guard let image = insight.image
         else {
            print("Error: Image is missing for the shared item.")
            return
        }
        
        let itemsToShare: [Any] = [image, insight.link]
        let activityController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        if let popoverController = activityController.popoverPresentationController {
            popoverController.sourceView = sender
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func savedInsightButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "bookmark.fill") {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
            InsightData.shared.removeInsight(id: sender.tag)
        } else {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            InsightData.shared.saveInsight(id: sender.tag)
        }
    }
    
}
