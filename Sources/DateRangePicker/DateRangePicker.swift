//
//  DateRangePicker.swift
//  
//
//  Created by Alessio Moiso on 14.04.23.
//

import SwiftUI

public struct DateRangePicker: View {
  enum Mode {
    case  calendar,
          picker
  }
  
  static let numberOfDaysInWeek = 7
  
  @Binding var month: Int
  @Binding var year: Int
  @Binding var selection: ClosedRange<Date>?
  
  @State private var months = [Date]()
  @State private var years = [Date]()
  @State private var dates = [Date]()
  @State private var mode = Mode.calendar
  
  @State private var startDate: Date?
  
  let calendar: Calendar
  private let datesGenerator: DatesGenerator
  
  init(
    calendar: Calendar = .autoupdatingCurrent,
    month: Binding<Int>,
    year: Binding<Int>,
    selection: Binding<ClosedRange<Date>?>
  ) {
    self.calendar = calendar
    datesGenerator = .init(calendar: calendar)
    self._month = month
    self._year = year
    self._selection = selection
  }
  
  public var body: some View {
    VStack {
      HStack(alignment: .center) {
        Button(action: toggleMode) {
          HStack {
            Text(formattedMonthYear)
              .foregroundColor(mode == .picker ? .accentColor : .primary)
              .bold()
            
            Image(systemName: "chevron.right")
              .imageScale(.small)
              .rotationEffect(mode == .picker ? Angle(degrees: 90) : Angle(degrees: 0))
          }
        }
        .padding([.leading])
        
        Spacer()
        
        HStack(spacing: 20) {
          Button(action: { increaseMonth(by: -1) }) {
            Image(systemName: "chevron.left")
              .imageScale(.large)
          }
          
          Button(action: { increaseMonth(by: 1) }) {
            Image(systemName: "chevron.right")
              .imageScale(.large)
          }
        }
        .padding(.trailing)
      }
      .padding(.bottom)
      .frame(maxWidth: .infinity, alignment: .leading)
      
      switch mode {
      case .calendar:
        HStack(spacing: 0) {
          ForEach(calendar.orderedShortWeekdaySymbols, id: \.self) { weekday in
            Text(weekday.uppercased())
              .foregroundColor(.secondary)
              .font(.subheadline)
              .bold()
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
        .padding([.leading, .trailing], 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        LazyVGrid(
          columns: Array(repeating: GridItem(.flexible()), count: Self.numberOfDaysInWeek),
          alignment: .center,
          spacing: 12
        ) {
          ForEach($dates, id: \.self) { $date in
            if isDateValid(date) {
              Button(action: { select(date: date) }) {
                let isDateSelected = isDateSelected(date)
                let useAccent = isToday(date) || isDateSelected
                
                Text(date.formattedDay ?? "")
                  .foregroundColor(useAccent ? .accentColor : .primary)
                  .fontWeight(isDateSelected ? .bold : .regular)
                  .padding([.top, .bottom], 8)
                  .padding([.leading, .trailing], 8)
                  .background(isDateSelected ? Color.accentColor.opacity(0.1) : .clear)
                  .cornerRadius(8)
              }
            } else {
              Text(date.formattedDay ?? "")
                .hidden()
            }
          }
        }
        .padding([.leading, .trailing], 12)
        .onAppear {
          generateVisibleMonth(month, year: year)
          generateMonths(in: year)
          generateYears()
        }
        .onChange(of: month) { newValue in
          generateVisibleMonth(newValue, year: year)
        }
        .onChange(of: year) { newValue in
          generateVisibleMonth(month, year: newValue)
          generateMonths(in: newValue)
        }
      case .picker:
        HStack(spacing: 0) {
          Picker("", selection: $month) {
            ForEach($months, id: \.self) { $monthDate in
              Text(monthDate.formattedMonth ?? "")
                .tag(monthDate.monthComponent(in: calendar))
            }
          }
          .pickerStyle(.wheel)
          
          Picker("", selection: $year) {
            ForEach($years, id: \.self) { $yearDate in
              Text(yearDate.formattedYear ?? "")
                .tag(yearDate.yearComponent(in: calendar))
            }
          }
          .pickerStyle(.wheel)
        }
        .padding([.leading, .trailing], 6)
      }
    }
  }
}

// MARK: - Logic
private extension DateRangePicker {
  func select(date: Date) {
    if startDate == nil {
      startDate = date
      return
    }
    
    if let startDate, selection == nil {
      if date < startDate {
        self.startDate = date
        return
      }
      selection = startDate...date
      return
    }
    
    if selection != nil {
      startDate = nil
      selection = nil
      return select(date: date)
    }
  }
  
  func toggleMode() {
    mode = (mode == .calendar ? .picker: .calendar)
  }
  
  func increaseMonth(by value: Int) {
    let dateComponents = DateComponents(year: year, month: month)
    guard
      let displayedDate = calendar.date(from: dateComponents),
      let nextMonth = calendar.date(byAdding: .month, value: value, to: displayedDate)
    else { return }
    
    let newComponents = calendar.dateComponents([.month, .year], from: nextMonth)
    
    guard
      let newYear = newComponents.year,
      let newMonth = newComponents.month
    else { return }
    
    year = newYear
    month = newMonth
  }
  
  func generateMonths(in year: Int) {
    months = datesGenerator.months(in: year)
  }
  
  func generateYears() {
    years = datesGenerator.years()
  }
  
  func generateVisibleMonth(_ month: Int, year: Int) {
    dates = datesGenerator.dates(in: month, of: year)
  }
  
  func isDateValid(_ date: Date) -> Bool {
    let dateComponents = DateComponents(year: year, month: month)
    guard
      let displayedDate = calendar.date(from: dateComponents)
    else { return false }
    
    return calendar.isDate(date, equalTo: displayedDate, toGranularity: .month)
  }
  
  func isToday(_ date: Date) -> Bool {
    calendar.isDateInToday(date)
  }
  
  func isDateSelected(_ date: Date) -> Bool {
    if let selection, selection.contains(date) {
      return true
    }
    
    return startDate == date
  }
  
  var formattedMonthYear: String {
    let components = DateComponents(year: year, month: month)
    guard
      let date = calendar.date(from: components)
    else { return "" }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM YYYY"
    return formatter.string(from: date)
  }
}

private extension Date {
  var formattedDay: String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter.string(from: self)
  }
  
  var formattedMonth: String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter.string(from: self)
  }
  
  var formattedYear: String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY"
    return formatter.string(from: self)
  }
  
  func monthComponent(in calendar: Calendar) -> Int {
    calendar.component(.month, from: self)
  }
  
  func yearComponent(in calendar: Calendar) -> Int {
    calendar.component(.year, from: self)
  }
}

extension Calendar {
  var orderedShortWeekdaySymbols: [String] {
    (Array(firstWeekday...7) + Array(1..<firstWeekday))
      .map {
        shortWeekdaySymbols[$0-1]
      }
  }
}

// MARK: - Preview
struct DateRangePicker_Previews: PreviewProvider {
  private struct Preview: View {
    let calendar: Calendar
    
    @State private var month = 04
    @State private var year = 2023
    @State private var range: ClosedRange<Date>?
    
    var body: some View {
      DateRangePicker(
        calendar: calendar,
        month: $month,
        year: $year,
        selection: $range
      )
    }
  }
  
  static var previews: some View {
    VStack {
      DatePicker("", selection: .constant(Date(timeIntervalSince1970: 0)))
      
      Preview(
        calendar: Calendar.gregorianItalian
      )
      .previewDisplayName("Gregorian - Italian")
    }
  }
}

private extension Calendar {
  static var gregorianEnglish: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en-US")
    return calendar
  }
  
  static var gregorianItalian: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "it-IT")
    return calendar
  }
}
