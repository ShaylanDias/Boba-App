//
//  ViewController.swift
//  BobaApp
//
//  Created by Shaylan Dias on 1/26/19.
//  Copyright © 2019 Shaylan Dias. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let defaultLocation = CLLocation(latitude: 37.331888, longitude: -122.029685)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets initial location to the Apple Campus
        centerMapOnLocation(location: defaultLocation)
        
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))

        self.mapView.setRegion(region, animated: true)
    }

}

