//
//  DateGridView.swift
//  
//
//  Created by Alessio Moiso on 15.04.23.
//

import SwiftUI

struct DateGridView: View {
  let calendar: Calendar
  let numberOfDaysInAWeek = 7
  let dates: [Date]
  
  let dateValidator: (Date) -> DateValidity
  let selectionProvider: (Date) -> Bool
  let selectionHandler: (Date) -> ()
  
  var body: some View {
    LazyVGrid(
      columns: Array(repeating: GridItem(.flexible()), count: numberOfDaysInAWeek),
      alignment: .center,
      spacing: 12
    ) {
      ForEach(dates, id: \.timeIntervalSinceReferenceDate) { date in
        let dateValidity = dateValidator(date)
        
        Button(action: { selectionHandler(date) }) {
          DayCell(
            content: date.formattedDay ?? "",
            isHighlighted: isToday(date),
            isSelected: selectionProvider(date),
            isEnabled: dateValidity == .available
          )
          .opacity(dateValidity != .hidden ? 1 : 0)
        }
        .disabled(dateValidity == .unavailable)
      }
    }
    .padding([.leading, .trailing], 12)
  }
}

private extension DateGridView {
  func isToday(_ date: Date) -> Bool {
    calendar.isDateInToday(date)
  }
}

private extension Date {
  var formattedDay: String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter.string(from: self)
  }
}

// MARK: - Preview
struct CalendarView_Previews: PreviewProvider {
  struct Preview: View {
    @State private var dates = [Date]()
    
    var body: some View {
      VStack(spacing: 20) {
        Text(dates.first?.formatted() ?? "")
          .font(.headline)
        
        Button(action: {
          withAnimation {
            dates = DatesGenerator(calendar: .autoupdatingCurrent)
              .dates(in: .random(in: 0..<12), of: .random(in: 1700..<2050))
          }
        }) {
          Text("Random Month")
        }
        
        Spacer()
          .frame(height: 40)
        
        DateGridView(
          calendar: .autoupdatingCurrent,
          dates: dates,
          dateValidator: { _ in .available },
          selectionProvider: { _ in false },
          selectionHandler: { _ in }
        )
        .onAppear {
          dates = DatesGenerator(calendar: .autoupdatingCurrent)
            .dates(in: 11, of: 1993)
        }
      }
    }
  }
  
  static var previews: some View {
    Preview()
  }
}
