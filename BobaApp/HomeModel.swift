//
//  HomeModel.swift
//  BobaApp
//
//  Created by Shaylan Dias on 3/21/19.
//  Copyright © 2019 Shaylan Dias. All rights reserved.
//

import UIKit

class HomeModel: NSObject {

    func getAllEntries() {
        // Hit the web service URL
        let serviceUrl = "http://bobaapp.com/service.php"
    /Users/shaylandias/Documents/BobaApp/BobaApp/Popover/README.md
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
        
        // Parse the JSON data into a Location struct
        
        // Notify the ViewController and pass the data back
    }
    
    func parseJson(_ data:Data) {
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            for each jsonResult in jsonArray {
                let jsonDict = jsonResult as! [String:String]
                let loc = Location(name: <#T##String#>, address: <#T##String#>, upvotes: <#T##Int#>, downvotes: <#T##Int#>, reviews: <#T##[String]#>)
            }
        }
        catch {
            print("Error With JSON Parse")
        }
    }
    
}
