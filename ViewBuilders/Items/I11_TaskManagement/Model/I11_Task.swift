//
//  I11_Task.swift
//  ViewBuilders
//
//  Created by kook on 2023/01/14.
//

import SwiftUI

// MARK: Task Model
struct I11_Task: Identifiable {
  var id: UUID = .init()
  var dateAdded: Date
  var taskName: String
  var taskDescription: String
  var taskCategory: I11_Category
}

// MARK: Category Enum with Color
enum I11_Category: String, CaseIterable {
  case general = "General"
  case bug = "Bug"
  case idea = "Idea"
  case modifiers = "Modifiers"
  case challenge = "Challenge"
  case coding = "Coding"

  var color: Color {
    switch self {
    case .general: return Color("I11_Gray")
    case .bug: return Color("I11_Green")
    case .idea: return Color("I11_Pink")
    case .modifiers: return Color("I11_Blue")
    case .challenge: return Color.purple
    case .coding: return Color.brown
    }
  }
}

/// - Sample Task
let I11_sampleTasks: [I11_Task] = [
  .init(dateAdded: getSampleDate(dayOffset: -1, hourOffset: 0),
        taskName: "Edit YT Video",
        taskDescription: "",
        taskCategory: .general),
  .init(dateAdded: getSampleDate(dayOffset: -1, hourOffset: 0),
        taskName: "Matched Geometry Effet(Issue)",
        taskDescription: "",
        taskCategory: .bug),
  .init(dateAdded: getSampleDate(dayOffset: 0, hourOffset: 0),
        taskName: "Multi-ScrollView",
        taskDescription: "",
        taskCategory: .challenge),
  .init(dateAdded: getSampleDate(dayOffset: 0, hourOffset: 0),
        taskName: "Loreal Ipsum",
        taskDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
        taskCategory: .idea),
  .init(dateAdded: getSampleDate(dayOffset: 0, hourOffset: 1),
        taskName: "Complete UI Animation Challenge",
        taskDescription: "",
        taskCategory: .challenge),
  .init(dateAdded: getSampleDate(dayOffset: 1, hourOffset: 1),
        taskName: "Fix Shadow issue on Mockup's",
        taskDescription: "",
        taskCategory: .bug),
  .init(dateAdded: getSampleDate(dayOffset: 1, hourOffset: 2),
        taskName: "Add Shadow Effect in Mockview App",
        taskDescription: "",
        taskCategory: .idea),
  .init(dateAdded: getSampleDate(dayOffset: 1, hourOffset: 2),
        taskName: "Twitter/Instagram Post",
        taskDescription: "",
        taskCategory: .general),
  .init(dateAdded: getSampleDate(dayOffset: 1, hourOffset: 4),
        taskName: "Lorem Ipsum",
        taskDescription: "",
        taskCategory: .modifiers)
]

fileprivate func getSampleDate(dayOffset: Int, hourOffset: Int) -> Date {
  let dayDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
  let date = Calendar.current.date(byAdding: .hour, value: hourOffset, to: dayDate)
  return date ?? Date()
}
