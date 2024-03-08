//
//  paymentRecord.swift
//  ExpenseTracking
//
//  Created by Baylor Harrison on 2/29/24.
//

import Foundation

class paymentRecord{
    var description: String? = nil
    var amount: String? = nil
    var category: String? = nil
    var time = Date()
    
    init(d: String, a: String, c: String, t: Date){
        self.description = d
        self.amount = a
        self.category = c
        self.time = t
    }
}
