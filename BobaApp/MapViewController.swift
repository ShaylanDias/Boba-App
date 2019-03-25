//
//  ViewController.swift
//  BobaApp
//
//  Created by Shaylan Dias on 1/26/19.
//  Copyright © 2019 Shaylan Dias. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, HomeModelDelegate {

    var homeModel = HomeModel()
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let defaultLocation = CLLocation(latitude: 37.331888, longitude: -122.029685)
    var mapItems: [MKMapItem] = []
    @IBOutlet weak var bobaButton: UIButton!
    @IBOutlet weak var iceCreamButton: UIButton!
    @IBOutlet weak var sushiButton: UIButton!
    @IBOutlet weak var pizzaButton: UIButton!
    var currentCategory: String = "this_should_return_nothing"
    var currentLoc:Location = Location()
    lazy var locView:LocationViewViewController = { tabBarController?.viewControllers![1] as? LocationViewViewController }()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeModel.delegate = self
        
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        bobaButton.setStyle()
        iceCreamButton.setStyle()
        pizzaButton.setStyle()
        sushiButton.setStyle()
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        mapView.delegate = self
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func getCurrentLocation() -> Location {
        return self.currentLoc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setCurrentLocation(location:Location) {
        currentLoc = location
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
            updateLocalSpots()
        }
        
        

//        self.mapView.setRegion(region, animated: true)
    }
    
    func itemsDownloaded(locations: [Location]) {
        print(locations)
    }
    
    func locationDownloaded(location: Location) {
        self.currentLoc = location
        print(location)
    }
    
    @IBAction func bobaPressed(_ sender: Any) {
        print("Boba pressed")
        currentCategory = "Boba"
        resetButtonTints()
        bobaButton.tintColor = self.view.tintColor
        updateLocalSpots()
    }
    
    @IBAction func iceCreamPressed(_ sender: Any) {
        print("Ice Cream pressed")
        currentCategory = "Ice Cream"
        resetButtonTints()
        iceCreamButton.tintColor = self.view.tintColor
        updateLocalSpots()
    }
    @IBAction func sushiPressed(_ sender: Any) {
        print("Sushi pressed")
        currentCategory = "Sushi"
        resetButtonTints()
        sushiButton.tintColor = self.view.tintColor
        updateLocalSpots()
        
    }
    @IBAction func pizzaPressed(_ sender: Any) {
        print("Pizza pressed")
        currentCategory = "Pizza"
        resetButtonTints()
        pizzaButton.tintColor = self.view.tintColor
        updateLocalSpots()
        
    }
    
    func resetButtonTints()
    {
        self.mapView.removeAnnotations(self.mapView.annotations)
        mapItems = []
        print("Length:")
        print(self.mapView.annotations.count)
        sushiButton.tintColor = UIColor.gray
        iceCreamButton.tintColor = UIColor.gray
        pizzaButton.tintColor = UIColor.gray
        bobaButton.tintColor = UIColor.gray
    }
    
    func updateLocalSpots()
    {
        let searchQuery = currentCategory
        print("Query:")
        print(searchQuery)
        let center = CLLocationCoordinate2D(latitude: previousLocation.coordinate.latitude, longitude: previousLocation.coordinate.longitude)
        
        let searchRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchQuery
        
        request.region = searchRegion
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error occurred in search:")
                print((error!.localizedDescription))
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                self.mapItems = response!.mapItems
                for item in response!.mapItems {
                                        print("Name = \(item.name!)")
                    let anno = MKPointAnnotation();
                    anno.coordinate = item.placemark.coordinate;
                    anno.title = item.name!
                    let pinView = MKAnnotationView.init(annotation: anno, reuseIdentifier: self.currentCategory)
                    
//                    self.mapView.addAnnotation(pinView)
                    self.mapView.addAnnotation(anno);
                    
                }
            }
        })
    }
    
    var previousLocation: CLLocation = CLLocation(latitude: 37.331888, longitude: -122.029685)
    
    

}

extension UIButton
{
    func setStyle()
    {
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
//        self.layer.masksToBounds = false
//        self.layer.shadowRadius = 1.0
//        self.layer.shadowOpacity = 0.5
//        self.layer.cornerRadius = self.frame.width / 2
        
        let cornerRadiusSize = CGFloat.init(12)
        
        self.tintColor = UIColor.gray
        
        self.layer.cornerRadius = cornerRadiusSize
        self.clipsToBounds = true
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubview(toFront: imageView)
        }
    }
    
    
}

extension MapViewController: MKMapViewDelegate {

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = view.annotation as? MKPointAnnotation
        let annoTitle = pin?.title
        let pinCoord = pin?.coordinate
        
        for item in self.mapItems
        {
            if item.placemark.coordinate.latitude == pinCoord?.latitude && item.placemark.coordinate.longitude == pinCoord?.longitude
            {
//                print(item.placemark.title!)
//                print(item.placemark.name!)
                
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: item.placemark.coordinate, addressDictionary:nil))
                mapItem.name = annoTitle
                homeModel.getLocation(item.placemark.title!, item.placemark.name!)
                Thread.sleep(forTimeInterval: TimeInterval(1))
                if(locView.isViewLoaded) {
                    locView.initializeForLocation(loc: currentLoc)
                }
                tabBarController?.selectedIndex = 1
//                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = #imageLiteral(resourceName: "Unicorn")
            let annoView = MKMarkerAnnotationView.init(annotation: annotation, reuseIdentifier: "annoView")
            
            if(self.currentCategory == "Sushi")
            {
                annoView.glyphImage = #imageLiteral(resourceName: "SushiIcon")
            }
            else if(self.currentCategory == "Ice Cream")
            {
                annoView.glyphImage = #imageLiteral(resourceName: "IceCreamIcon")
            }
            else if(self.currentCategory == "Pizza")
            {
                annoView.glyphImage = #imageLiteral(resourceName: "PizzaIcon")
            }
            else if(self.currentCategory == "Boba")
            {
                annoView.glyphImage = #imageLiteral(resourceName: "BobaIcon")
            }
            
            annoView.titleVisibility = .adaptive
            return annoView
            
        } else
        {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }

}
