//
//  ComponentsFormatter.swift
//  DateRangePicker
//
//  Created by Alessio Moiso on 10/12/24.
//

import Foundation

final class ComponentsFormatter {
	let calendar: Calendar
	
	private lazy var monthFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = calendar.timeZone
		formatter.dateFormat = "MMMM"
		return formatter
	}()
	
	private lazy var yearFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = calendar.timeZone
		formatter.dateFormat = "yyyy"
		return formatter
	}()
	
	private lazy var yearMonthFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeZone = calendar.timeZone
		formatter.dateFormat = "MMMM yyyy"
		return formatter
	}()
	
	init(calendar: Calendar) {
		self.calendar = calendar
	}
	
	func month(of date: Date) -> String? {
		monthFormatter.string(from: date)
	}
	
	func year(of date: Date) -> String? {
		yearFormatter.string(from: date)
	}
	
	func yearAndMonth(of date: Date) -> String? {
		yearMonthFormatter.string(from: date)
	}
}
