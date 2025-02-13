//
//  File.swift
//  DateRangePicker
//
//  Created by hw0102 on 2/13/25.
//

import Foundation

extension Date {

    // return the greater of max and min. nil if max is missing
    static func maxDate(min: Date?, max: Date?) -> Date? {
        if let max {
            if let min {
                return max > min ? max : min
            }
            return max
        }
        return nil
    }
}
