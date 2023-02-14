//
//  I9_Home.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/09.
//

import SwiftUI

struct I9_Home: View {
  @State private var text: String = ""
  @State private var tags: [I9_Tag] = []
  @State private var showAlert: Bool = false
  
  var body: some View {
    VStack {
      Text("Filter\nMenus")
        .font(.system(size: 38, weight: .bold))
        .foregroundColor(Color("I9_Tag"))
        .frame(maxWidth: .infinity, alignment: .leading)
      
      I9_TagView(maxLimit: 150, tags: $tags)
        .frame(height: 280)
        .padding(.top, 20)
      
      TextField("apple", text: $text)
        .font(.title3)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color("I9_Tag").opacity(0.2), lineWidth: 1)
        )
        .environment(\.colorScheme, .dark)
        .padding(.vertical, 18)
      
      Button {
        // Adding Tag
        addTag(tags: tags, text: text, fontSize: 16, maxLimit: 150) { alert, tag in
          if alert {
            // showing alert
            showAlert.toggle()
          } else {
            // adding Tag
            tags.append(tag)
            text = ""
          }
        }
      } label: {
        Text("Add Tag")
          .fontWeight(.semibold)
          .foregroundColor(Color("I9_BG"))
          .padding(.vertical, 12)
          .padding(.horizontal, 45)
          .background(Color("I9_Tag"))
          .cornerRadius(10)
      }
      .disabled(text == "")
      .opacity(text == "" ? 0.6 : 1)
    }
    .padding(15)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(
      Color("I9_BG")
        .ignoresSafeArea()
    )
    .alert(isPresented: $showAlert) {
      Alert(title: Text("Error"), message: Text("Tag Limit Exceeded. try to delete some tags"),
            dismissButton: .destructive(Text("OK")))
    }
  }
}

struct I9_Home_Previews: PreviewProvider {
  static var previews: some View {
    I9_Home()
  }
}

fileprivate func addTag(tags: [I9_Tag], text: String, fontSize: CGFloat, maxLimit: Int,
                        completion: @escaping (Bool, I9_Tag) -> Void) {
  
  // Getting Text Size
  let font = UIFont.systemFont(ofSize: fontSize)
  let attributes = [NSAttributedString.Key.font: font]
  
  let size = (text as NSString).size(withAttributes: attributes)
  
  let tag = I9_Tag(text: text, size: size.width)
  
  if (getSize(tags: tags) + text.count) <  maxLimit {
    completion(false, tag)
  } else {
    completion(true, tag)
  }
}

fileprivate func getSize(tags: [I9_Tag]) -> Int {
  var count: Int = 0
  
  tags.forEach { tag in
    count += tag.text.count
  }
  
  return count
}
