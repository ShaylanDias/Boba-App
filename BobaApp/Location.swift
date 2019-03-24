//
//  Location.swift
//  BobaApp
//
//  Created by Shaylan Dias on 3/21/19.
//  Copyright © 2019 Shaylan Dias. All rights reserved.
//

import Foundation

class Location : CustomStringConvertible {
    var name = ""
    var address = ""
    var upvotes = 0
    var downvotes = 0
    var reviews = [""]
    
    init(name:String, address:String, upvotes:Int, downvotes:Int, reviews:[String]) {
        self.name = name
        self.address = address
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.reviews = reviews
    }
    
    func setReviews(reviews:[String]) {
        self.reviews = reviews
    }
    
    public var description: String { return self.reviews.description }

}
