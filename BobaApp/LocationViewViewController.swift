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

    var currentLoc:Location? = Location(name:"No Location Selected", address:"No Location Selected", upvotes:0, downvotes:0, reviews:[""])
    @IBOutlet weak var toMap: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var upvote: UIButton!
    @IBOutlet weak var downvote: UIButton!
    @IBOutlet weak var voteDisplay: UILabel!
    
    @IBOutlet weak var locName: UILabel!
    @IBOutlet weak var leaveAReviewLabel: UILabel!
    @IBOutlet weak var leaveAReviewText: UITextView!
    
    var locationName:String = ""
    var locAddress:String = ""
    
    lazy var mapViewer:MapViewController = { tabBarController?.viewControllers![0] as? MapViewController }()!

    let locationManager = CLLocationManager()
    var previousLocation = CLLocation(latitude: 37.331888, longitude: -122.029685)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upvote.setStyle()
        upvote.setStyle()
        toMap.setStyle()
        
        locName.text = ""
        leaveAReviewLabel.text = "Leave a Review:"
        leaveAReviewText.text = ""
        leaveAReviewText.isEditable = true
        mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()

        }
        mapView.delegate = self
        
//        initializeLoading()
//        initializeForLocation(loc:self.mapViewer.currentLoc)
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        //        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        initializeForLocation(loc:self.mapViewer.currentLoc)
        self.toLocationView(self.locAddress, self.locationName)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.currentLoc = nil
//        initializeLoading()
    }
    
    func printReviews() {
        reviewText.isEditable = false
        reviewText.text = "REVIEWS:"
        let reviews = currentLoc!.getReviews()
        if reviews.count > 0 {
            for review in reviews {
                reviewText.text.append("\n\n-" + review)
            }
        } else {
            reviewText.text = "No Reviews Yet."
        }
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
        print("Upvote pressed")
        if(currentLoc == nil) {
            return
        }
        upvote.tintColor = self.view.tintColor
        // Hit the web service URL
        let serviceUrl = ("http://bobaapp.com/upvote-location.php?address=" + currentLoc!.address + "&name=" + currentLoc!.name).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(serviceUrl)
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
                    self.currentLoc!.incUpvotes()
                }
                else {
                    // Error Occurred
                }
            })
            
            // Start the task
            task.resume()
        }
        self.voteDisplay.text = String(self.currentLoc!.getScore() + 1)

    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        print("Downvote pressed")
        if(currentLoc == nil) {
            return
        }
        downvote.tintColor = self.view.tintColor
        // Hit the web service URL
        let serviceUrl = ("http://bobaapp.com/downvote-location.php?address=" + currentLoc!.address + "&name=" + currentLoc!.name ).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(serviceUrl)
        
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
                    self.currentLoc!.incDownvotes()
                }
                else {
                    // Error Occurred
                }
            })
            
            // Start the task
            task.resume()
        }
        self.voteDisplay.text = String(self.currentLoc!.getScore() - 1)

    }
    
    @IBAction func toMapPressed(_ sender: Any) {
        print("ToMap pressed")
        if(currentLoc != nil && currentLoc!.name != "No Location Selected") {
            let address = currentLoc!.address
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
    
    func initializeLoading() {
        locName.text = "Loading"
        reviewText.text = "Loading"
        voteDisplay.text = "Loading"
    }
    
    func initializeForLocation(loc:Location) {
        if(currentLoc == nil) {
            return
        }
        currentLoc = loc
        print(currentLoc)
        voteDisplay.text = String(loc.getScore())
        let address = loc.getAddress()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                if var region = self?.mapView.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 180
                    region.span.latitudeDelta /= 180
                    self?.mapView.setRegion(region, animated: true)
                    self?.mapView.addAnnotation(mark)
                }
            }
        }
        locName.text = currentLoc!.name
        printReviews()
    }
    
    @IBAction func syncReview(_ sender: Any) {
        
        if(currentLoc == nil) {
            return
        }
        
        var text = ""
        if(leaveAReviewText.text.count > 200) {
            text = String(leaveAReviewText.text.prefix(200))
        }
        else {
            text = leaveAReviewText.text
        }
        
        let serviceUrl = ("http://bobaapp.com/add-review.php?address=" + currentLoc!.address + "&review=" + text).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
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
                    self.currentLoc!.incDownvotes()
                }
                else {
                    // Error Occurred
                }
            })
            
            // Start the task
            task.resume()
        }
        
        leaveAReviewText.text = ""
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
 
    func toLocationView(_ address:String, _ name:String) {
        // Hit the web service URL
        let locationURL = ("http://bobaapp.com/select-locations.php?address=" + address + "&name=" + name).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(locationURL)
        
        let reviewURL = ("http://bobaapp.com/select-reviews.php?address=" + address).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(reviewURL)
        // Download the JSON data
        let locationUrl = URL(string: locationURL)
        let reviewUrl = URL(string: reviewURL)
        
        if let locUrl = locationUrl {
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: locUrl, completionHandler:
            {(data, response, error) in
                if error == nil {
                    // Successfully received data
                    let locArray =  self.parseJson(data!)
                    let loc = locArray[0]
                    // Starting to retrieve reviews
                    if let revUrl = reviewUrl {
                        let task2 = session.dataTask(with: revUrl, completionHandler:
                        {(data2, response2, error2) in
                            if error2 == nil {
                                // Successfully received data
                                loc.setReviews(reviews:self.parseReviews(data2!))
                                self.currentLoc = loc
                                DispatchQueue.main.async {
                                    self.initializeForLocation(loc: self.currentLoc!)
                                }
                            }
                            else {
                                // Error Occurred
                            }
                        })
                        task2.resume()
                    }
                    else {
                        // Error Occurred
                    }
                }
            })
            
            // Start the task
            task.resume()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func parseReviews(_ data:Data) -> [String]{
        var revArray = [String]()
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            for jsonResult in jsonArray {
                let jsonDict = jsonResult as! [String:String]
                do {
                    var review = jsonDict["review"]
                    if(review == nil) {
                        review = ""
                    }
                    revArray.append(review!)
                }
            }
        }
        catch {
            print("Error With JSON Parse")
        }
        return revArray
    }
    
    func parseJson(_ data:Data) -> [Location] {
        
        var locArray = [Location]()
        
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for jsonResult in jsonArray {
                let jsonDict = jsonResult as! [String:String]
                var locName = jsonDict["Name"]
                if locName == nil {
                    locName = ""
                }
                var locAddress = jsonDict["Address"]
                if locAddress == nil {
                    locAddress = ""
                }
                var locUpvotes = Int(jsonDict["Upvotes"]!)
                if locUpvotes == nil {
                    locUpvotes = 0
                }
                var locDownvotes = Int(jsonDict["Downvotes"]!)
                if locDownvotes == nil {
                    locDownvotes = 0
                }
                let loc = Location(name: locName!, address: locAddress!, upvotes: (locUpvotes)!, downvotes: (locDownvotes)!, reviews: [""])
                locArray.append(loc)
            }
        }
        catch {
            print("Error With JSON Parse")
        }
        return locArray
    }

    
}
