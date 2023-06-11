//
//  I14_CustomFilteringDataView.swift
//  ViewBuilders
//
//  Created by kook on 2023/06/11.
//

import SwiftUI

struct I14_CustomFilteringDataView<Content: View>: View {
  
  var content: ([I14_Task], [I14_Task]) -> Content
  @FetchRequest private var result: FetchedResults<I14_Task>
  @Binding private var filterDate: Date
  init(filterDate: Binding<Date>, @ViewBuilder content: @escaping ([I14_Task], [I14_Task]) -> Content) {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: filterDate.wrappedValue)
    let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
    
    let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])
    
    _result = FetchRequest(entity: I14_Task.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \I14_Task.date, ascending: false)
    ], predicate: predicate, animation: .easeInOut(duration: 0.25))
    
    self.content = content
    self._filterDate = filterDate
  }
  
  var body: some View {
    content(separateTasks().0, separateTasks().1)
      .onChange(of: filterDate) { newValue in
        result.nsPredicate = nil
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: newValue)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startOfDay, endOfDay])
        
        result.nsPredicate = predicate
      }
  }
  
  func separateTasks() -> ([I14_Task], [I14_Task]) {
    let pendingTasks = result.filter { !$0.isCompleted }
    let completedTasks = result.filter { $0.isCompleted }
    
    return (pendingTasks, completedTasks)
  }
  
}

struct I14_CustomFilteringDataView_Previews: PreviewProvider {
  static var previews: some View {
    I14_Home()
  }
}
