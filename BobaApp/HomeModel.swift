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
    
}

class HomeModel: NSObject {

    var delegate:HomeModelDelegate?
    
    func getLocation(_ address:String, _ name:String) {
        // Hit the web service URL
        let serviceUrl = "http://bobaapp.com/select-locations.php?address=\'" + address + "\'&name=\'" + name + "\'"
        
        // Download the JSON data
        let url = URL(string: serviceUrl)
        
        if let url = url {
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if error == nil {
                    // Successfully received data
                    self.parseJson(data!)
                }
                else {
                    // Error Occurred
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
                    self.parseJson(data!)
                }
                else {
                    // Error Occurred
                }
            })
            
            // Start the task
            task.resume()
        }

    }
    
    func parseJson(_ data:Data) {
        
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
            
            // Pass location array back to delegate
            delegate?.itemsDownloaded(locations: locArray)
            
        }
        catch {
            print("Error With JSON Parse")
        }
    }
    
}
