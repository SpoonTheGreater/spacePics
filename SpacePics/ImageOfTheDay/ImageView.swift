//
//  ImageView.swift
//  SpacePics
//
//  Created by James Sadlier on 25/01/2020.
//  Copyright © 2020 jamSoft. All rights reserved.
//

import SwiftUI

struct ImageView: View {
  
  var imageOfTheDay: ImageOfTheDay
  
  @State var imageDownloaded: Bool = false
  @State var image: UIImage?
  
  var body: some View {
    List() {
      if imageDownloaded {
        Image(uiImage: self.image!)
          .resizable()
          .aspectRatio(contentMode: ContentMode.fit)
      }
      Text("\(imageOfTheDay.explanation)")
    }
    .navigationBarTitle(Text("\(imageOfTheDay.title)"))
    .onAppear {
      self.imageOfTheDay.downloadImage(hd: false) { sdImage in
        self.imageDownloaded = true
        self.image = sdImage
      }
    }
  }
}

struct ImageView_Previews: PreviewProvider {
  
  static var previews: some View {
    NavigationView {
      ImageView(imageOfTheDay: ImageOfTheDay.debugPreview())
    }
  }
}
