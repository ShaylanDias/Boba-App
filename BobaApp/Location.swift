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
    var reviews = ["Delicious snack like shaylan, good, bad, okay"]
    
    init() {
        
    }
    
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
    
    func getAddress() -> String {
        return self.address
    }
    
    func getName() -> String {
        return self.name
    }
    
    func incUpvotes() {
        self.upvotes += 1
    }
    
    func incDownvotes() {
        self.downvotes += 1
    }
    
    func getUpvotes() -> Int {
        return self.upvotes
    }
    
    func getDownvotes() -> Int {
        return self.downvotes
    }
    
    func getScore() -> Int {
        return (self.upvotes - self.downvotes)
    }
    
    func getReviews() -> [String] {
        return self.reviews
    }
    
    public var description: String { return "[\(self.name), \(self.address), \(self.upvotes), \(self.downvotes), \(self.reviews)]" }

}
