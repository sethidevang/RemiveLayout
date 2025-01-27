//
//  ViewController.swift
//  Remive
//
//  Created by Dakshdeep Singh - University on 11/12/24.
//

import UIKit
import MapKit


protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

protocol PediatricianSelectionDelegate: AnyObject {
    func didSelectPediatrician(_ pediatrician: Pediatrician)
}

class ViewController: UIViewController, CLLocationManagerDelegate, PediatricianSelectionDelegate, UISearchBarDelegate {
    func didSelectPediatrician(_ pediatrician: Pediatrician) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: pediatrician.location, span: span)
        mapView.setRegion(region, animated: true)
        
       
        for annotation in mapView.annotations {
            if annotation.coordinate.latitude == pediatrician.location.latitude &&
                annotation.coordinate.longitude == pediatrician.location.longitude {
                mapView.selectAnnotation(annotation, animated: true)
                break
            }
        }
    }
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var pediatricianResults: [Pediatrician] = []
    weak var delegate: DismissPediatricianSelectionDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Search Location"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        searchBar.backgroundColor = UIColor.systemGray6
        navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    @objc func getDirections() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions: [String: Any] = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
   
    func presentPediatriciansHalfSheet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pediatriciansVC = storyboard.instantiateViewController(withIdentifier: "PediatriciansListTableViewController") as? PediatriciansListTableViewController {
            
            // Pass the pediatricians data to the new view controller
            pediatriciansVC.pediatricianResults = self.pediatricianResults
            print(pediatriciansVC.pediatricianResults)
            
            // Embed the table view controller in a navigation controller
            let nav = UINavigationController(rootViewController: pediatriciansVC)
            
            // Configure the half-sheet presentation
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [
                    .custom { context in return 50 },
                    .custom(identifier: .customHeight, resolver: { context in
                        250
                    }),
                    .medium(),
                    .large()
                ]
                sheet.preferredCornerRadius = 16
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.selectedDetentIdentifier = .customHeight
            }

            present(nav, animated: true, completion: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension UISheetPresentationController.Detent.Identifier {
    static let customHeight = UISheetPresentationController.Detent.Identifier("customHeight")
}

extension ViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Create a coordinate region based on the current location
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)

            // Create a placemark from the current location
            let placemark = MKPlacemark(coordinate: location.coordinate)
            
            // Call dropPinZoomIn to update the map and search results
            dropPinZoomIn(placemark: placemark)
            
            // Set the search bar text to the current location address (if available)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemarks = placemarks, let firstPlacemark = placemarks.first {
                    let address = firstPlacemark.name ?? "Unknown Location"
                    DispatchQueue.main.async {
                        self?.resultSearchController?.searchBar.text = address
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error: \(error)")
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)

        getPediatriciansNearLocation(placemark.coordinate) { [weak self] pediatricians in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.pediatricianResults = pediatricians

                // Add annotations to the map
                for pediatrician in pediatricians {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = pediatrician.location
                    annotation.title = pediatrician.name
                    annotation.subtitle = pediatrician.specialty
                    self.mapView.addAnnotation(annotation)
                }

                // Zoom in on the selected location
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)

                // Present the pediatricians list on the half-sheet
                if let presentedVC = self.presentedViewController as? UINavigationController,
                   let pediatriciansVC = presentedVC.viewControllers.first as? PediatriciansListTableViewController {
                    pediatriciansVC.pediatricianResults = self.pediatricianResults
                    pediatriciansVC.tableView.reloadData()
                } else {
                    self.presentPediatriciansHalfSheet()
                }
            }
        }
    }

    func getPediatriciansNearLocation(_ coordinate: CLLocationCoordinate2D, completion: @escaping ([Pediatrician]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pediatrician"
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Error fetching pediatricians: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            let pediatricians = response.mapItems.map { mapItem in
                Pediatrician(
                    name: mapItem.name ?? "Unknown",
                    location: mapItem.placemark.coordinate,
                    specialty: mapItem.phoneNumber ?? "No Phone Number found"
                )
            }
            completion(pediatricians)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 40, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(systemName: "car.fill"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
