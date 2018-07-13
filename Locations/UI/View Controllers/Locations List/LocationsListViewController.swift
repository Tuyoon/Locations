//
//  LocationsListViewController.swift
//  Locations
//
//  Created by AT on 05/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import RealmSwift

protocol LocationsListViewControllerDelegate: class {
    func locationsListViewControllerDidSelectLocationOnMap(controller: LocationsListViewController, location: Location)
}

class LocationsListViewController: UIViewController {

    weak var delegate: LocationsListViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!

    private var notificationToken: NotificationToken!
    private lazy var realmLocations: Results<Location> = self.loadLocations()
    private lazy var locations: [Location] = []
    
    private var locationManager: LocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        locationManager = LocationManager(delegate: self)
        
        notificationToken = LocationsManager.observe({ [weak self] (_) in
            self?.updateUI()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadLocations() -> Results<Location> {
        return LocationsManager.locations()
    }
    
    private func sortLocations() {
        locations = realmLocations.sorted(by: { (location1, location2) -> Bool in
            let distance1 = location1.coordinate.distance(from: locationManager.coordinate)
            let distance2 = location2.coordinate.distance(from: locationManager.coordinate)
            return distance1 < distance2
        })
    }
    
    private func updateUI() {
        sortLocations()
        tableView.reloadData()
    }
}

extension LocationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationTableViewCell
        let location = locations[indexPath.row]
        cell.location = location
        cell.delegate = self
        
        return cell
    }
}

extension LocationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller: LocationViewController = LocationViewController.controller()
        controller.location = locations[indexPath.row]
        present(controller, animated: true, completion: nil)
    }
}

extension LocationsListViewController: LocationManagerDelegate {
    func locationManagerDidUpdate(manager: LocationManager) {
        updateUI()
    }
}

extension LocationsListViewController: LocationTableViewCellDelegate {
    func locationTableViewCellDidSelectMap(_ cell: LocationTableViewCell) {
        self.delegate?.locationsListViewControllerDidSelectLocationOnMap(controller: self, location: cell.location)
    }
}
