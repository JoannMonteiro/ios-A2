//
//  PizzaOrder.swift
//  SliceMaster
//
//  Created by Joann Monteiro on 2026-07-16.
//

import Foundation

class PizzaOrder {
    
    // properties match the DB columns
    var rowID: Int?
    var deliveryDate: String?
    var address: String?
    var size: Int?
    var meatToppings: String?
    var vegToppings: String?
    var avatar: String?
    
    init() {
        // empty init
    }
    
    // helper to fill all properties at once
    func fillIn(theRowID: Int,
                theDeliveryDate: String,
                theAddress: String,
                theSize: Int,
                theMeatToppings: String,
                theVegToppings: String,
                theAvatar: String) {
        
        self.rowID = theRowID
        self.deliveryDate = theDeliveryDate
        self.address = theAddress
        self.size = theSize
        self.meatToppings = theMeatToppings
        self.vegToppings = theVegToppings
        self.avatar = theAvatar
    }
}
