//
//  infoDictionary.swift
//  ExpenseTracking
//
//  Created by Baylor Harrison on 2/29/24.
//

import Foundation

class infoDictionary: ObservableObject{
    @Published var infoRepository : [String:paymentRecord] = [String:paymentRecord]()
    
    @Published var description: String = ""
        @Published var amount: String = ""
        @Published var category: String = ""
        @Published var time: Date = Date()
    
    init(){}
    
    func add(_ description:String, _ amount:String, _ category:String, _ time:Date){
        let pRecord = paymentRecord(d: description, a: amount, c: category, t: time)
        infoRepository[pRecord.description!] = pRecord
    }
    
    func total() -> Double {
        var total: Double = 0.0
        for (_, payment) in infoRepository {
            if let amount = payment.amount {
                total += Double(amount)!
            }
        }
        return total
    }
    
}
