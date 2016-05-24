//
//  Spice.swift
//  Spice Rack
//
//  Created by Matt Dickey on 3/1/16.
//  Copyright © 2016 Matt Dickey. All rights reserved.
//

import Foundation
import RealmSwift

class Spice: Object {
    
    dynamic var name : String = ""
    dynamic var netWt: Double = 0.0
    dynamic var unit : String = "oz"
    dynamic var volumeRemaining : Double = 0.0
    dynamic var percentageRemaining : Double = 100.0
    
    // Optional
    dynamic var brand : String?
    dynamic var purchaseDate : NSDate?
    dynamic var expDate : NSDate?
    dynamic var imageName : String?
    
    
    func calculatePercentage() -> Double{
        percentageRemaining = (self.volumeRemaining / self.netWt) * 100
        return percentageRemaining.roundToPlaces(1)
    }
    
    
    func getDetails() -> String{
        let summary = String("You have \(volumeRemaining)\(unit) of \(name) from the original \(netWt)\(unit) container which is \(calculatePercentage())%.")
        
        return summary
    }

}

