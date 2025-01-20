//
//  LocationSearchTableViewController.swift
//  Remive
//
//  Created by Dakshdeep Singh - University on 11/12/24.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        var addressParts: [String] = []

        // Add street number and name if they exist
        if let subThoroughfare = selectedItem.subThoroughfare,
           !subThoroughfare.isEmpty {
            addressParts.append(subThoroughfare)
        }
        
        if let thoroughfare = selectedItem.thoroughfare,
           !thoroughfare.isEmpty {
            if !addressParts.isEmpty {
                addressParts.append(thoroughfare) // Add a space if street number is present
            } else {
                addressParts.append(thoroughfare)
            }
        }

        // Add city if it exists
        if let locality = selectedItem.locality,
           !locality.isEmpty {
            addressParts.append(locality)
        }

        // Add state if it exists
        if let administrativeArea = selectedItem.administrativeArea, !administrativeArea.isEmpty {
            addressParts.append(administrativeArea)
        }

        // Combine the address parts with commas and spaces
        let addressLine = addressParts.joined(separator: ", ")
        
        return addressLine
    }


}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        
        return cell
    }
    
}

extension LocationSearchTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
