//
//  ContentView.swift
//  SpacePics
//
//  Created by James Sadlier on 25/01/2020.
//  Copyright © 2020 jamSoft. All rights reserved.
//

import SwiftUI
import UIKit
import SwiftUISpinner

struct HomeView: View {
  
  @State var spinnerAnimating: Bool = true
  
  @State var imageOfTheDay: ImageOfTheDay?
  @State var loadedImage: Bool = false
  
  @State var detailsView: AnyView = AnyView(EmptyView())
  @State var showingImageDetails: Bool = false
  
  var body: some View {
    NavigationView {
      VStack {
        Group {
          NavigationLink(destination: detailsView, isActive: self.$showingImageDetails) {
            EmptyView()
          }
        }
        if loadedImage == false {
          VStack {
            SwiftUISpinner(animating: true)
            Text("Loading...")
          }
        } else {
          Text("Loaded")
          Button(action: {
            self.detailsView = self.generateImageView(imageOfTheDay: self.imageOfTheDay)
            self.showingImageDetails = true
          }) {
            Text("View \(imageOfTheDay?.title ?? "image")")
          }
        }
      }
    }
    .onAppear {
      if self.loadedImage == false {
        NASAServices.getImageOfTheDay { image in
          if image != nil {
            self.imageOfTheDay = image
            self.loadedImage = true
          }
        }
      }
    }
  }
  
  func generateImageView(imageOfTheDay: ImageOfTheDay?) -> AnyView {
    if let iotd = imageOfTheDay {
      return AnyView(DetailsView(imageOfTheDay: iotd))
    }
    return AnyView(EmptyView())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(imageOfTheDay: nil)
  }
}

