//
//  MapViewController.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
    func mapViewControllerDidSelect(controller: MapViewController, location: Location)
    func mapViewControllerDidOpen(controller: MapViewController, location: Location)
    func mapViewControllerDidDeselect(controller: MapViewController)
    func mapViewControllerDidSelectAdd(controller: MapViewController, coordinate: CLLocationCoordinate2D)
}

let regionRadius: CLLocationDistance = 13000

class MapViewController: UIViewController {
    weak var delegate: MapViewControllerDelegate?
    
    @IBOutlet private weak var mapView: MKMapView!
    
    var location: Location? {
        didSet {
            if location != oldValue {
                updateSelectedAnnotation()
            }
        }
    }
    
    var locations: [Location] = [] {
        didSet {
            updateAnnotations()
        }
    }
    
    var selectedAnnotations: [MKAnnotation] {
        get {
            return self.mapView.selectedAnnotations
        }
    }

    private var locationManager: LocationManager!
    private var addLocationAnnotation: AddLocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        locationManager = LocationManager(delegate: self)
        mapView.mapType = .mutedStandard
        mapView.showsUserLocation = true
        mapView.register(AddLocationMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.addButtonPressed(sender:)))
        mapView.addGestureRecognizer(gesture)
        moveTo(coordinate: locationManager.coordinate)
    }

    @objc private func addButtonPressed(sender: UILongPressGestureRecognizer) {
        guard sender.state == UIGestureRecognizerState.ended else {
            return
        }
        
        let point = sender.location(in: mapView)
        if let annotation = addLocationAnnotation {
            mapView.removeAnnotation(annotation)
        }
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        addLocationAnnotation = AddLocationAnnotation(coordinate: coordinate)
        mapView.addAnnotation(addLocationAnnotation!)
    }
    
    private func updateAnnotations() {

        mapView.removeAnnotations(mapView.annotations)

        for location in locations {
            let annotation = LocationAnnotation(location: location)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func updateSelectedAnnotation() {
        guard let selected = self.location else {
            return
        }
        
        for annotation in mapView.annotations {
            if let location = (annotation as? LocationAnnotation)?.location, location == selected {
                if !mapView.annotations(in: mapView.visibleMapRect).contains(annotation as! AnyHashable) {
                    mapView.centerCoordinate = annotation.coordinate
                }
                mapView.selectAnnotation(annotation, animated: true)
                break
            }
        }
    }
    
    private func moveTo(coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    private func createAddLocationAnnotationView(_ annotation: MKAnnotation) -> MKAnnotationView? {
        guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            as? MKMarkerAnnotationView else {
                return nil
        }
        view.annotation = annotation
        return view
    }
    
    private func createLocationAnnotationView(_ annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LocationAnnotation else {
            return nil
        }
        
        let identifier = "annotation"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            view.annotation = annotation
            return view
        }
        
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return view
    }
}

extension MapViewController: LocationManagerDelegate {
    func locationManagerDidUpdate(manager: LocationManager) {
        moveTo(coordinate: manager.coordinate)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is AddLocationAnnotation {
            delegate?.mapViewControllerDidSelectAdd(controller: self, coordinate: view.annotation!.coordinate)
            mapView.deselectAnnotation(view.annotation!, animated: true)
            return
        }
        
        if let location = (view.annotation as? LocationAnnotation)?.location {
            self.location = location
            delegate?.mapViewControllerDidSelect(controller: self, location:  location)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is LocationAnnotation {
            location = nil
            delegate?.mapViewControllerDidDeselect(controller: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is AddLocationAnnotation {
            return createAddLocationAnnotationView(annotation)
        }
        
        return createLocationAnnotationView(annotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let location = (view.annotation as? LocationAnnotation)?.location else {
            return
        }
        
        if self.location == location {
            delegate?.mapViewControllerDidOpen(controller: self, location: location)
            return
        }
    }
}
