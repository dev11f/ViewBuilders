//
//  I9_TagView.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/09.
//

import SwiftUI

struct I9_TagView: View {
  var maxLimit: Int
  @Binding var tags: [I9_Tag]
  
  private let title = "Add Some Tags"
  
  private let fontSize: CGFloat = 16
  
  // Adding Geometry Effect to Tag
  @Namespace var animation
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      
      Text(title)
        .font(.callout)
        .foregroundColor(Color("I9_Tag"))
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading, spacing: 10) {
          ForEach(getRows(), id: \.self) { row in
            HStack(spacing: 6) {
              ForEach(row) { tag in
                RowView(tag: tag)
              }
            }
          }
        }
        .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
        .padding(.vertical)
        .padding(.bottom, 20)
      }
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .strokeBorder(Color("I9_Tag").opacity(0.15), lineWidth: 1)
      )
      // Animation
      .animation(.easeInOut, value: tags)
      .overlay(
        Text("\(getSize(tags: tags))/\(maxLimit)")
          .font(.system(size: 13, weight: .semibold))
          .foregroundColor(Color("I9_Tag"))
          .padding(12),
        alignment: .bottomTrailing
      )
    }
  }
  
  @ViewBuilder
  private func RowView(tag: I9_Tag) -> some View {
    Text(tag.text)
    // applying same font size
    // else size will vary
      .font(.system(size: fontSize))
      .foregroundColor(Color("I9_BG"))
      .padding(.vertical, 8)
      .padding(.horizontal, 14)
      .background(
        Capsule()
          .fill(Color("I9_Tag"))
      )
      .lineLimit(1)
    // Delete
      .contentShape(Capsule())
      .contextMenu {
        Button("Delete") {
          tags.remove(at: getIndex(tag: tag))
        }
      }
      .matchedGeometryEffect(id: tag.id, in: animation)
  }
  
  private func getIndex(tag: I9_Tag) -> Int {
    let index = tags.firstIndex { currentTag in
      tag.id == currentTag.id
    } ?? 0
    
    return index
  }
  
  // Basic Logic
  // Splitting the array when it exceeds the screen size
  private func getRows() -> [[I9_Tag]] {
    var rows: [[I9_Tag]] = []
    var currentRow: [I9_Tag] = []
    
    var totalWidth: CGFloat = 0
    
    // For safety add extra 10
    let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
    
    tags.forEach { tag in
      // updating total width
      // adding the capsule size into total width with spacing
      // 14 + 14 + 6 + 6
      // extra 6 for safety
      totalWidth += (tag.size + 40)
      
      // checking if totalwidth is greater than size
      if totalWidth > screenWidth {
        //checking for long string
        totalWidth = !currentRow.isEmpty || rows.isEmpty ? tag.size + 40 : 0
        
        rows.append(currentRow)
        currentRow.removeAll()
        currentRow.append(tag)
      } else {
        currentRow.append(tag)
      }
    }
    
    // Safe Check if having any value storing it in rows
    if !currentRow.isEmpty {
      rows.append(currentRow)
      currentRow.removeAll()
    }
    
    return rows
  }
  
}

struct I9_TagView_Previews: PreviewProvider {
  static var previews: some View {
    I9_Home()
  }
}

fileprivate func getSize(tags: [I9_Tag]) -> Int {
  var count: Int = 0
  
  tags.forEach { tag in
    count += tag.text.count
  }
  
  return count
}
