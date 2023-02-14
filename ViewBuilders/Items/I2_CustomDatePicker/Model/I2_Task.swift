//
//  I2_Task.swift
//  ViewBuilders
//
//  Created by kook on 2022/11/29.
//

import Foundation

struct I2_Task: Identifiable {
  var id = UUID().uuidString
  var title: String
  var time: Date = Date()
}

struct I2_TaskMetaData: Identifiable {
  var id = UUID().uuidString
  var task: [I2_Task]
  var taskDate: Date
}

fileprivate func getSampleDate(offset: Int) -> Date {
  let date = Calendar.current.date(byAdding: .day, value: offset, to: Date())
  
  return date ?? Date()
}

var I2_Tasks: [I2_TaskMetaData] = [
  I2_TaskMetaData(task: [
    I2_Task(title: "Talk to iJustine"),
    I2_Task(title: "iPhone 13 Great Design Change"),
    I2_Task(title: "Nothing Much Workout!!!"),
  ], taskDate: getSampleDate(offset: 1)),
  
  I2_TaskMetaData(task: [
    I2_Task(title: "Talk to Jenna Ezarik")
  ], taskDate: getSampleDate(offset: -3)),
  
  I2_TaskMetaData(task: [
    I2_Task(title: "Meeting with Tim Cook")
  ], taskDate: getSampleDate(offset: -8)),
  
  I2_TaskMetaData(task: [
    I2_Task(title: "Next Version of SwiftUI")
  ], taskDate: getSampleDate(offset: 10)),
  
  I2_TaskMetaData(task: [
    I2_Task(title: "Nothing Much Workout!!!")
  ], taskDate: getSampleDate(offset: -22)),
  
  I2_TaskMetaData(task: [
    I2_Task(title: "iPhone 13 Great Design Change")
  ], taskDate: getSampleDate(offset: 15)),
  
  I2_TaskMetaData(task: [
    I2_Task(title: "Dev11f App Updates...")
  ], taskDate: getSampleDate(offset: -20)),
  
]
