//
//  Date+Uther.swift
//  Uther
//
//  Created by why on 31/01/2017.
//  Copyright © 2017 callmewhy. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter.string(from: self)
    }

    func startTime() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endTime() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startTime())!
    }
}
