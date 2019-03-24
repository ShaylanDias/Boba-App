//
//  PageViewController.swift
//  BobaApp
//
//  Created by Shaylan Dias on 3/8/19.
//  Copyright © 2019 Shaylan Dias. All rights reserved.
//

import UIKit
import MapKit

class PageViewController: UIPageViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var currentLoc:Location = Location()
    @IBOutlet weak var toMap: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var upvote: UIButton!
    @IBOutlet weak var downvote: UIButton!
    @IBOutlet weak var voteDisplay: UILabel!
    
    let locationManager = CLLocationManager()
    var previousLocation = CLLocation(latitude: 37.331888, longitude: -122.029685)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.view
        upvote.setStyle()
        upvote.setStyle()
        toMap.setStyle()

        
//        mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
//        mapView.delegate = self

    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
//        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
        print("Upvote pressed")
//        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
//        upvoteButton.tintColor = self.view.tintColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForLocation(loc:Location) {
        let location = loc.getAddress()
        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
//            if let placemark = placemarks?.first, let location = placemark.location {
//                let mark = MKPlacemark(placemark: placemark)
//
//                if var region = self?.mapView.region {
//                    region.center = location.coordinate
//                    region.span.longitudeDelta /= 8.0
//                    region.span.latitudeDelta /= 8.0
//                    self?.mapView.setRegion(region, animated: true)
//                    self?.mapView.addAnnotation(mark)
//                }
//            }
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let distance = location.distance(from: previousLocation)
//        mapView.showsPointsOfInterest = false
        
        //        let searchRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        if(distance > 40.0)
        {
            previousLocation = location
        }
        
        //        self.mapView.setRegion(region, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

