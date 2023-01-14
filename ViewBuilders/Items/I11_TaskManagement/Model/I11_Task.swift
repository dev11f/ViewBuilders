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
var I11_sampleTasks: [I11_Task] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1673690749), taskName: "Edit YT Video", taskDescription: "", taskCategory: .general),
    .init(dateAdded: Date(timeIntervalSince1970: 1673690749), taskName: "Matched Geometry Effet(Issue)", taskDescription: "", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1673694349), taskName: "Multi-ScrollView", taskDescription: "", taskCategory: .challenge),
    .init(dateAdded: Date(timeIntervalSince1970: 1673694409), taskName: "Loreal Ipsum", taskDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.", taskCategory: .idea),
    .init(dateAdded: Date(timeIntervalSince1970: 1673714609), taskName: "Complete UI Animation Challenge", taskDescription: "", taskCategory: .challenge),
    .init(dateAdded: Date(timeIntervalSince1970: 1673851409), taskName: "Fix Shadow issue on Mockup's", taskDescription: "", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1673791729), taskName: "Add Shadow Effect in Mockview App", taskDescription: "", taskCategory: .idea),
    .init(dateAdded: Date(timeIntervalSince1970: 1673791729), taskName: "Twitter/Instagram Post", taskDescription: "", taskCategory: .general),
    .init(dateAdded: Date(timeIntervalSince1970: 1673923409), taskName: "Lorem Ipsum", taskDescription: "", taskCategory: .modifiers)

]
