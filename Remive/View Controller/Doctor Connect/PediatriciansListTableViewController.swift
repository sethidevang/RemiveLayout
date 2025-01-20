//
//  PediatriciansListTableViewController.swift
//  Remive
//
//  Created by Dakshdeep Singh - University on 18/12/24.
//

import UIKit
import MapKit


protocol DismissPediatricianSelectionDelegate: AnyObject {
    func didClickCancelButton()
}

class PediatriciansListTableViewController: UITableViewController, DismissPediatricianSelectionDelegate {
    func didClickCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    var pediatricianResults: [Pediatrician] = []
    weak var delegate: PediatricianSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register a default cell for the table view
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PediatricianCell")
        navigationItem.title = "Nearby Pediatricians"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(pediatricianResults)
        return pediatricianResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PediatricianCell", for: indexPath)
        let pediatrician = pediatricianResults[indexPath.row]
        
        var defaultCell = cell.defaultContentConfiguration()
        defaultCell.text = pediatrician.name
        defaultCell.secondaryText = "Phone Number:\(pediatrician.specialty)"
        cell.contentConfiguration = defaultCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedPediatrician = pediatricianResults[indexPath.row]
//        delegate?.didSelectPediatrician(selectedPediatrician)
        
        let selectedPediatrician = pediatricianResults[indexPath.row]
        
        let pediatricianLocation = selectedPediatrician.location
        let placemark = MKPlacemark(coordinate: pediatricianLocation)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = selectedPediatrician.name
        
        let launchOptions: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        mapItem.openInMaps(launchOptions: launchOptions)
    }

}
