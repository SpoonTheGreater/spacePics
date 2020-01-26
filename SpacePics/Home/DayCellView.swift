//
//  DayCellView.swift
//  SpacePics
//
//  Created by James Sadlier on 26/01/2020.
//  Copyright © 2020 jamSoft. All rights reserved.
//

import SwiftUI

struct DayCellView: View {
  
  public var imageData: ImageOfTheDay
  
  var body: some View {
    HStack {
      Image(imageData.imageName)
        .resizable()
        .aspectRatio(contentMode: ContentMode.fit)
      VStack {
        Text(imageData.title)
        Text("\(imageData.dateString())")
      }
    }
  }
}

struct DayCellView_Previews: PreviewProvider {
  static let cellData: [ImageOfTheDay] = DayCellView_Previews.previewImages()
  
  static var previews: some View {
    List() {
      ForEach(cellData) { cell in
        DayCellView(imageData: cell)
      }
    }
  }
  
  static func previewImages() -> [ImageOfTheDay] {
    guard let url = Bundle.main.url(forResource: "imageOfTheDay", withExtension: "json"),
      let data = try? Data(contentsOf: url) else {
      return []
    }
    
    if let testArray = try? JSONDecoder().decode([ImageOfTheDay].self, from: data) {
      return testArray
    }
    return []
  }
}
