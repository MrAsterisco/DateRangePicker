//
//  DatesGenerator.swift
//  
//
//  Created by Alessio Moiso on 14.04.23.
//

import Foundation

/// A generator that creates array of dates based on a set interval.
public final class DatesGenerator {
	/// The default minimum year to use when generating 
	/// years if none is specified.
	public static let defaultMinimumYear = 1700
	/// The default amount of years to add to the current year 
	/// when generating years if none is specified.
	public static let defaultMaximumYearsInterval = 100
	
	private let calendar: Calendar
	
	/// Initialize a new `DatesGenerator` instance.
	///
	/// - Parameter calendar: A calendar.
	public init(
		calendar: Calendar
	) {
		self.calendar = calendar
	}
	
	/// Generate an array of years between the given dates.
	///
	/// - note: Each date in the array is the first day of the year. 
	///
	/// - Parameters:
	///   - minimumDate: The minimum date to consider. Defaults to the first day of the year 1700, for performance reasons.
	///   - maximumDate: The maximum date to consider. Defaults to 100 years in the future from now, for performance reasons.
	/// - Returns: An array of dates.
	func years(minimumDate: Date?, maximumDate: Date?) -> [Date] {
		calendar.dates(
			in: .init(
				start: minimumDate
				?? calendar.date(from: .init(year: 1700))
				?? Date.distantPast,
				end: maximumDate
				?? calendar.date(byAdding: .init(year: 100), to: Date())
				?? Date.distantFuture
			),
			byMatching: .init(month: 1)
		)
	}
	
	/// Generate an array of months in the given year.
	/// - Parameters:
	///   - year: The year to consider.
	///   - minimumDate: The minimum date to consider. Defaults to the beginning of the year.
	///   - maximumDate: The maximum date to consider. Defaults to the end of the year.
	/// - Returns: An array of dates.
	func months(in year: Int, minimumDate: Date?, maximumDate: Date?) -> [Date] {
		let dateComponents = DateComponents(year: year)
		guard
			let date = calendar.date(from: dateComponents),
			let yearInterval = calendar.dateInterval(of: .year, for: date)?.clamped(minimumDate: minimumDate, maximumDate: maximumDate)
		else { return [] }
		
		return calendar.dates(
			in: yearInterval,
			byMatching: DateComponents(day: 1)
		)
	}
	
	/// Generate an array of dates in the given month and year, ensuring that
	/// the result contains entirely the first and last week of the month,
	/// even if some days fall outside of the month.
	/// - Parameters:
	///   - month: The month to consider.
	///   - year: The year to consider.
	/// - Returns: An array of dates.
	public func dates(in month: Int, of year: Int) -> [Date] {
		guard
			let interval = dateIntervalEnforcingFullWeeks(month: month, year: year)
		else { return [] }
		
		return calendar.dates(
			in: interval,
			byMatching: DateComponents(hour: 0)
		)
	}
}

private extension DatesGenerator {
	func dateIntervalEnforcingFullWeeks(month: Int, year: Int) -> DateInterval? {
		let dateComponents = DateComponents(year: year, month: month)
		guard
			let date = calendar.date(from: dateComponents),
			let monthInterval = calendar.dateInterval(of: .month, for: date),
			let firstWeekInterval = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
			let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end)
		else { return nil }
		
		return DateInterval(
			start: min(monthInterval.start, firstWeekInterval.start),
			end: max(monthInterval.end, lastWeekInterval.end)
		)
	}
}

private extension Calendar {
	func dates(in interval: DateInterval, byMatching dateComponents: DateComponents) -> [Date] {
		var dates: [Date] = []
		
		dates.append(interval.start)
		
		enumerateDates(startingAfter: interval.start, matching: dateComponents, matchingPolicy: .nextTime) { date, _, stop in
			guard let date else { return }
			
			if date < interval.end {
				dates.append(date)
			} else {
				stop = true
			}
		}
		return dates
	}
}

private extension DateInterval {
	func clamped(minimumDate: Date? = nil, maximumDate: Date? = nil) -> Self {
		var start: Date = self.start
		var end: Date = self.end
		
		if let minimumDate {
			start = max(minimumDate, start)
		}
		
		if let maximumDate {
			end = min(maximumDate, end)
		}
		
        if start < end {
            preconditionFailure("start date must be before end date", file: #file, line: #line)
        }
        
		return Self.init(start: start, end: end)
	}
}
