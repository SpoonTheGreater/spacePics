//
//  DetailsView.swift
//  SpacePics
//
//  Created by James Sadlier on 25/01/2020.
//  Copyright © 2020 jamSoft. All rights reserved.
//

import SwiftUI
import SwiftUISpinner

struct DetailsView: View {
  
  var imageOfTheDay: ImageOfTheDay
  
  @State var imageDownloaded: Bool = false
  @State var image: UIImage?
  
  var body: some View {
    List() {
      Section(header:
      Text("\(imageOfTheDay.title)").font(Font.title)
      ) {
        imageView(uiImage: self.image, imageDownloaded: imageDownloaded)
        Text("\(imageOfTheDay.explanation)")
      }
    }
    .navigationBarTitle("Image of the Day")
    .onAppear {
      self.imageOfTheDay.downloadImage(hd: false) { sdImage in
        if let downloadedImage = sdImage {
          sleep(3)
          self.imageDownloaded = true
          self.image = downloadedImage
        }
      }
    }
  }
}

func imageView(uiImage: UIImage?, imageDownloaded: Bool) -> AnyView {
  if let downloadedImage = uiImage, imageDownloaded {
    return AnyView(
      Image(uiImage: downloadedImage)
        .resizable()
        .aspectRatio(contentMode: ContentMode.fit)
    )
  }
  return AnyView(HStack{
    SwiftUISpinner(animating: true)
    Text("Downloading Image")
  })
}

struct DetailsView_Previews: PreviewProvider {
  
  static var previews: some View {
    Group {
      ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
        NavigationView {
          DetailsView(imageOfTheDay: ImageOfTheDay.debugPreview())
        }.environment(\.colorScheme, colorScheme)
      }
      
//        .previewDevice(PreviewDevice(rawValue: " 11 Pro Max"))
//        .previewDisplayName("11 Pro Max")
//       .environment(\.sizeCategory, .accessibilityExtraLarge)
////        .environment(\.colorScheme, .dark)
////        .previewLayout(.fixed(width: 812, height: 375))
//
//      NavigationView {
//        DetailsView(imageOfTheDay: ImageOfTheDay.debugPreview())
//      }
//        .previewDevice(PreviewDevice(rawValue: " 11 Pro Max"))
//        .previewDisplayName("11 Pro Max")
////        .environment(\.colorScheme, .dark)
//
//      NavigationView {
//              DetailsView(imageOfTheDay: ImageOfTheDay.debugPreview())
//            }
//              .previewDevice("iPhone SE")
    }
  }
}
