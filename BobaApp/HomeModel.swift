//
//  HomeModel.swift
//  BobaApp
//
//  Created by Shaylan Dias on 3/21/19.
//  Copyright © 2019 Shaylan Dias. All rights reserved.
//

import UIKit

protocol HomeModelDelegate {
    
    func itemsDownloaded(locations:[Location])
    
    func locationDownloaded(location:Location)
    
}

class HomeModel: NSObject {

    var delegate:HomeModelDelegate?
    
    func getLocation(_ address:String, _ name:String) {
        // Hit the web service URL
        let locationURL = ("http://bobaapp.com/select-locations.php?address=" + address + "&name=" + name).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(locationURL)
        
        let reviewURL = ("http://bobaapp.com/select-reviews.php?address=" + address).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
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
                                    self.delegate?.locationDownloaded(location: loc)
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
    
    func getAllEntries() {
        // Hit the web service URL
        let serviceUrl = "http://bobaapp.com/service.php"
        
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
                    self.delegate?.itemsDownloaded(locations: self.parseJson(data!))
                }
                else {
                    // Error Occurred
                }
            })
            
            // Start the task
            task.resume()
        }

    }
    
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
