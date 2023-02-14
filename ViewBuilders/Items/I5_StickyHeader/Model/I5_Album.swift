//
//  I4_Album.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/05.
//

import Foundation

// MARK: Album Model and Sample Data
struct I5_Album: Identifiable {
  var id = UUID().uuidString
  var albumName: String
}

var I5_albums: [I5_Album] = [
  .init(albumName: "In Between"),
  .init(albumName: "More"),
  .init(albumName: "Big Jet Plane"),
  .init(albumName: "Empty Floor"),
  .init(albumName: "Black Hole Nights"),
  .init(albumName: "Rain On Me"),
  .init(albumName: "Stuck With U"),
  .init(albumName: "7 rings"),
  .init(albumName: "Bang Bang"),
  .init(albumName: "In Between"),
  .init(albumName: "More"),
  .init(albumName: "Big Jet Plane"),
  .init(albumName: "Empty Floor"),
  .init(albumName: "Black Hole Nights")
]
