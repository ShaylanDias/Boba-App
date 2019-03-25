//
//  LocationViewViewController.swift
//  BobaApp
//
//  Created by Shaylan Dias on 3/24/19.
//  Copyright © 2019 Shaylan Dias. All rights reserved.
//

import UIKit
import MapKit

class LocationViewViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var currentLoc:Location = Location(name:"No Location Selected", address:"No Location Selected", upvotes:0, downvotes:0, reviews:[""])
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
        upvote.setStyle()
        upvote.setStyle()
        toMap.setStyle()
        
        mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()

        }
        mapView.delegate = self
        
        initializeForLocation(loc: currentLoc)
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        //        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
        print("Upvote pressed")
        upvote.tintColor = self.view.tintColor
        // Hit the web service URL
        let serviceUrl = ("http://bobaapp.com/vote-on-location.php?address=" + currentLoc.address + "&name=" + currentLoc.name + "&up=true").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // Download the JSON data
        let url = URL(string: serviceUrl)
        
        if let url = url {
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if error == nil {
                    // Successfully received data
                    // Pass location array back to delegate
                    self.currentLoc.incUpvotes()
                }
                else {
                    // Error Occurred
                }
            })
            
            // Start the task
            task.resume()
        }
        self.voteDisplay.text = String(self.currentLoc.getScore() + 1)

    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        print("Downvote pressed")
        downvote.tintColor = self.view.tintColor
        // Hit the web service URL
        let serviceUrl = ("http://bobaapp.com/vote-on-location.php?address=" + currentLoc.address + "&name=" + currentLoc.name + "&up=false").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // Download the JSON data
        let url = URL(string: serviceUrl)
        
        if let url = url {
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if error == nil {
                    // Successfully received data
                    // Pass location array back to delegate
                    self.currentLoc.incDownvotes()
                }
                else {
                    // Error Occurred
                }
            })
            
            // Start the task
            task.resume()
        }
        self.voteDisplay.text = String(self.currentLoc.getScore() - 1)

    }
    
    @IBAction func toMapPressed(_ sender: Any) {
        print("ToMap pressed")
        if(currentLoc.name != "No Location Selected") {
            let address = currentLoc.address
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        // handle no location found
                        return
                }
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary:nil))
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            }
        
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForLocation(loc:Location) {
        currentLoc = loc
        voteDisplay.text = String(loc.getScore())
        let address = loc.getAddress()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                if var region = self?.mapView.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 270.0
                    region.span.latitudeDelta /= 270.0
                    self?.mapView.setRegion(region, animated: true)
                    self?.mapView.addAnnotation(mark)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let distance = location.distance(from: previousLocation)
        mapView.showsPointsOfInterest = false
        
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
