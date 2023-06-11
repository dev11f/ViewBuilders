//
//  I14_Home.swift
//  ViewBuilders
//
//  Created by kook on 2023/06/11.
//

import SwiftUI

struct I14_Home: View {
  /// View Properties
  @Environment(\.self) private var env
  @State private var fileterDate: Date = .init()
  @State private var showPendingTasks: Bool = true
  @State private var showCompletedTasks: Bool = true
  
  var body: some View {
    List {
      DatePicker(selection: $fileterDate, displayedComponents: [.date]) {
        
      }
      .labelsHidden()
      .datePickerStyle(.graphical)
      
      I14_CustomFilteringDataView(filterDate: $fileterDate) { pendingTasks, completedTasks in
        DisclosureGroup(isExpanded: $showPendingTasks) {
          if pendingTasks.isEmpty {
            Text("No Task's Found")
              .font(.caption)
              .foregroundColor(.gray)
          } else {
            ForEach(pendingTasks) {
              I14_TaskRow(task: $0, isPendingTask: true)
            }
          }
        } label: {
          Text("Pending Task's \(pendingTasks.isEmpty ? "" : "(\(pendingTasks.count))")")
            .font(.caption)
            .foregroundColor(.gray)
        }
        
        DisclosureGroup(isExpanded: $showCompletedTasks) {
          if completedTasks.isEmpty {
            Text("No Task's Found")
              .font(.caption)
              .foregroundColor(.gray)
          } else {
            ForEach(completedTasks) {
              I14_TaskRow(task: $0, isPendingTask: false)
            }
          }
        } label: {
          Text("Completed Task's \(completedTasks.isEmpty ? "" : "(\(completedTasks.count))")")
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .bottomBar) {
        Button {
          /// Simply Opening Pending Task View
          /// Then Adding an Empty Task
          do {
            let task = I14_Task(context: env.managedObjectContext)
            task.id = .init()
            task.date = fileterDate
            task.title = ""
            task.isCompleted = false
            
            try env.managedObjectContext.save()
            showPendingTasks = true
          } catch {
            print(error.localizedDescription)
          }
        } label: {
          HStack {
            Image(systemName: "plus.circle.fill")
              .font(.title3)
            
            Text("New Task")
          }
          .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

struct I14_Home_Previews: PreviewProvider {
  static var previews: some View {
    I14_ContentView()
  }
}

fileprivate struct I14_TaskRow: View {
  /// Core Data Object는 @ObservedObject 를 바로 붙여 사용할 수 있다
  @ObservedObject var task: I14_Task
  var isPendingTask: Bool
  /// View Properties
  @Environment(\.self) private var env
  @FocusState private var showKeyboard: Bool
  
  var body: some View {
    HStack(spacing: 12) {
      Button {
        task.isCompleted.toggle()
        save()
      } label: {
        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
          .font(.title)
          .foregroundColor(.blue)
      }
      .buttonStyle(.plain)
      
      VStack(alignment: .leading, spacing: 4) {
        TextField("Task Title", text: .init(get: { task.title ?? "" }, set: { task.title = $0 }))
          .focused($showKeyboard)
          .onSubmit {
            removeEmptyTask()
            save()
          }
          .foregroundColor(isPendingTask ? .primary : .gray)
          .strikethrough(!isPendingTask, pattern: .dash, color: .primary)
        
        /// Custom Date Picker
        Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
          .font(.callout)
          .foregroundColor(.gray)
          .overlay {
            DatePicker(selection: .init(get: {
              task.date ?? .init()
            }, set: {
              task.date = $0
              save()
            }), displayedComponents: [.hourAndMinute]) {
              
            }
            .labelsHidden()
            /// Hiding View by Utilizing BlendMode Modifier
            .blendMode(.destinationOver)
          }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .onAppear {
      if (task.title ?? "").isEmpty {
        showKeyboard = true
      }
    }
    .onDisappear {
      removeEmptyTask()
      save()
    }
    /// Verifying Content when user leaves the App
    .onChange(of: env.scenePhase) { newValue in
      if newValue != .active {
        showKeyboard = false
        DispatchQueue.main.async {
          removeEmptyTask()
          save()
        }
      }
    }
    /// Adding Swipe to Delete
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      Button(role: .destructive) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          env.managedObjectContext.delete(task)
          save()
        }
      } label: {
        Image(systemName: "trash.fill")
      }

    }
  }
  
  /// Context Saving Method
  func save() {
    do {
      try env.managedObjectContext.save()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  /// Removing Empty Task
  func removeEmptyTask() {
    if (task.title ?? "").isEmpty {
      env.managedObjectContext.delete(task)
    }
  }
}
