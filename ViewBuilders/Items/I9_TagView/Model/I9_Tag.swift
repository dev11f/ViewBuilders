//
//  I9_Tag.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/09.
//

import Foundation

struct I9_Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
