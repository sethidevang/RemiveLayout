//
//  CureAskTableViewController.swift
//  cureAsk1
//
//  Created by Devang IOS on 17/12/24.
//

import UIKit

class CureAskTableViewController: UITableViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var collectionViewRemedyCell: UICollectionView!
    @IBOutlet weak var kidNameLabel: UILabel!
    
    // List of symptoms
    private var selectedSymptoms: Set<String> = []
    private var selectedRemedies: [Remedy] = []
    private var selectedIngredient: Remedy?
    private var finalSymptom: String = ""
    private var selectedChildId: Int = 1
    
    init?(coder: NSCoder, id: Int) {
        selectedChildId = id
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionViewRemedyCell.collectionViewLayout=createLayout()
        collectionViewRemedyCell.dataSource = self

        submitButtonOutlet.layer.cornerRadius = 30
        submitButtonOutlet.isEnabled = false
        
        if let kid = FamilyManager.shared.getChildDetails(byID: selectedChildId) {
            kidNameLabel.text = "\(kid.firstName) \(kid.lastName ?? "")"
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return RemedySuggestionsModel.shared.getSymptomTitles().count
        } else if collectionView == self.collectionViewRemedyCell {
            return selectedRemedies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            // Symptom Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cure", for: indexPath) as! SymptomCollectionViewCell
            //                let symptom = symptoms[indexPath.row]
            let symptom = RemedySuggestionsModel.shared.getSymptomTitles()[indexPath.row]
            //            cell.symptomButton.text = symptom
            if traitCollection.userInterfaceStyle == .dark {
                cell.symptomButton.tintColor = .white // White border for Dark Mode
            }
            cell.symptomButton.setTitle(symptom, for: .normal)
            
            // Set the border for the button and the corner radius
            cell.symptomButton.layer.borderWidth = 2.0
            cell.symptomButton.layer.cornerRadius = 10
            cell.symptomButton.layer.masksToBounds = true
            cell.symptomButton.layer.borderColor = CGColor(red: 0.961, green: 0.039, blue: 0.329, alpha: 1.0)
            

            
            return cell
        } else if collectionView == self.collectionViewRemedyCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "remedyShow", for: indexPath) as! RemedyShowCollectionViewCell
            let remedy = selectedRemedies[indexPath.item]
            cell.remedyButton.setTitle(remedy.title, for: .normal)
            
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = CGColor(red: 0.961, green: 0.039, blue: 0.329, alpha: 1.0)
            if traitCollection.userInterfaceStyle == .dark {
                cell.remedyButton.tintColor = .white
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func updateRemedies() {
        for symptom in selectedSymptoms {
            let remedies = RemedySuggestionsModel.shared.selectSymptom(symptom, selectedChildId: selectedChildId)
        }
        print("Selected Symptoms: \(selectedSymptoms)")
        print("Remedies: \(selectedRemedies)")
        collectionViewRemedyCell.reloadData()
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.33), // 4 items per row
                        heightDimension: .fractionalHeight(1.0) // Full height for the group
                    )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0) // Add spacing between items
            
            // Define the size for the group (a row of 4 items)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), // Full width of the screen
                heightDimension: .absolute(35) // Set a fixed height for the group
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Create a section using the group
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10 // Spacing between rows
            
            return section
        }
    }
//   var check = false
    var lastSelectedButton: UIButton?
    @IBAction func buttonPressed(_ sender: UIButton) {
        submitButtonOutlet.isEnabled = false
        if let lastButton = lastSelectedButton {
            lastButton.layer.backgroundColor = nil // Set it back to default color
            lastButton.tintColor = .black // Reset the text color (optional)
        }
        sender.layer.backgroundColor = CGColor(red: 0.941, green: 0.039, blue: 0.329, alpha: 1.0) // #FF0A54
        sender.tintColor = .white
        
        // Store the current button as the last selected button
        lastSelectedButton = sender
        // Store the current button as the last selected button
        RemedySuggestionsModel.shared.clearContent()
        RemedySuggestionsModel.shared.selectSymptom((sender.titleLabel?.text)!, selectedChildId: selectedChildId)
        finalSymptom = (sender.titleLabel?.text)!
        selectedRemedies.removeAll()
        selectedRemedies.append(contentsOf: RemedySuggestionsModel.shared.getRemedies())
        tableView.reloadData()
        collectionViewRemedyCell.reloadData()
    }
    var lastRemedySelectedIngredient: UIButton? = nil
    @IBAction func remedyButtonTapped(_ sender: UIButton) {
        if let lastButton = lastRemedySelectedIngredient {
            lastButton.layer.backgroundColor = nil // Set it back to default color
//            lastButton.layer.backgroundColor = UIColor.clear.cgColor
            lastButton.tintColor = .black // Reset the text color (optional)
        }
        sender.layer.backgroundColor = CGColor(red: 0.941, green: 0.039, blue: 0.329, alpha: 1.0) // #FF0A54
        sender.tintColor = .white
                
                // Store the current button as the last selected button
        lastRemedySelectedIngredient = sender
        
        for remedy in selectedRemedies {
            if remedy.title == sender.titleLabel?.text {
                selectedIngredient = remedy
            }
        }
        submitButtonOutlet.isEnabled = true
        
    }
    @IBSegueAction func moveCureTip(_ coder: NSCoder, sender: Any?) -> CureTipViewController? {
        FamilyManager.shared.addChildSearchHistory(toChildID: selectedChildId, condition: finalSymptom, remedy: selectedIngredient!)
        return CureTipViewController(coder: coder, data: selectedIngredient, symptom: finalSymptom)
    }
   
    @IBAction func submitButton(_ sender: UIButton) {
        sender.layer.cornerRadius = 30
//        submitButtonOutlet.layer.cornerRadius = 20
        
    }
    
    @IBAction func unwindToCureAsk(_ unwindSegue: UIStoryboardSegue) {
    }
    
}
