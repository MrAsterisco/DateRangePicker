//
//  MonthYearPickerView.swift
//
//
//  Created by Alessio Moiso on 15.04.23.
//

import SwiftUI

struct MonthYearPickerView: View {
	let calendar: Calendar
	let formatter: ComponentsFormatter
	
	@Binding var months: [Date]
	@Binding var years: [Date]
	
	@Binding var selectedMonth: Int
	@Binding var selectedYear: Int
	
	var body: some View {
		HStack(spacing: 0) {
			Picker("", selection: $selectedMonth) {
				ForEach($months, id: \.self) { $monthDate in
					Text(formatter.month(of: monthDate) ?? "")
						.tag(monthDate.monthComponent(in: calendar))
				}
			}
			.pickerStyle(.wheel)
			
			Picker("", selection: $selectedYear) {
				ForEach($years, id: \.self) { $yearDate in
					Text(formatter.year(of: yearDate) ?? "")
						.tag(yearDate.yearComponent(in: calendar))
				}
			}
			.pickerStyle(.wheel)
		}
	}
}

private extension Date {
	func monthComponent(in calendar: Calendar) -> Int {
		calendar.component(.month, from: self)
	}
	
	func yearComponent(in calendar: Calendar) -> Int {
		calendar.component(.year, from: self)
	}
}

struct SwiftUIView_Previews: PreviewProvider {
	static var previews: some View {
		MonthYearPickerView(
			calendar: .autoupdatingCurrent,
			formatter: .init(calendar: .autoupdatingCurrent),
			months: .constant(
				DatesGenerator(calendar: .current).months(in: 2001, minimumDate: nil, maximumDate: nil)
			),
			years: .constant(
				DatesGenerator(calendar: .current).years(minimumDate: nil, maximumDate: nil)
			),
			selectedMonth: .constant(1),
			selectedYear: .constant(2017)
		)
	}
}
