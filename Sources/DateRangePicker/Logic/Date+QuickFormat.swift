//
//  Date+QuickFormat.swift
//
//
//  Created by Alessio Moiso on 15.04.23.
//

import Foundation

// MARK: - Convenience Methods
extension Date {
	static func date(from dateString: String) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: dateString)!
	}
}
