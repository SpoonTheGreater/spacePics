//
//  ContentView.swift
//  SpacePics
//
//  Created by James Sadlier on 25/01/2020.
//  Copyright © 2020 jamSoft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @State var imageOfTheDay: ImageOfTheDay?
  @State var loadedImage: Bool = false
  
  @State var imageView: AnyView = AnyView(EmptyView())
  @State var showingImageDetails: Bool = false
  
  var body: some View {
    NavigationView {
      VStack {
        Group {
          NavigationLink(destination: imageView, isActive: self.$showingImageDetails) {
            EmptyView()
          }
        }
        if loadedImage == false {
          Text("Loading...")
        } else {
          Text("Loaded")
          Button(action: {
            self.imageView = self.generateImageView(imageOfTheDay: self.imageOfTheDay)
            self.showingImageDetails = true
          }) {
            Text("View \(imageOfTheDay?.title ?? "image")")
          }
        }
      }
    }
    .onAppear {
      if self.loadedImage == false {
        NASAImage.getImageOfTheDay { image in
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
      return AnyView(ImageView(imageOfTheDay: iotd))
    }
    return AnyView(EmptyView())
  }
}

struct ContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    ContentView(imageOfTheDay: nil)
  }
}


public class NASAImage {
  
  private static let TEST_API_KEY = "aQnDa5JJC5BmREtEhoYDb84Z9wA4yN2f38fz1vB5"
  
  public static let requestString = "https://api.nasa.gov/planetary/apod?api_key=\(NASAImage.TEST_API_KEY)"
  
  public static func getImageOfTheDay( completion: @escaping (ImageOfTheDay?) -> Void) {
    guard let requestURL = URL(string: NASAImage.requestString) else {
      print("Error creating requestURL")
      completion(nil)
      return
    }
    var request = URLRequest(url: requestURL)
    request.httpMethod = "GET"
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
      
      guard let nasaData = data else {
        if let error = error {
          print("Error: \(error)")
        }
        completion(nil)
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.NASADate)
        let imageOfTheDay = try JSONDecoder().decode(ImageOfTheDay.self, from: nasaData)
        completion(imageOfTheDay)
      } catch {
        print("Error: \(error)")
        completion(nil)
        return
      }
    })
    task.resume()
  }
}

public class ImageOfTheDay: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case date
    case explanation
    case hdurl
    case media_type
    case service_version
    case title
    case url
  }
  
  public var date: Date
  public var explanation: String
  public var hdurl: String
  public var media_type: String
  public var service_version: String
  public var title: String
  public var url: String
  
  required public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    self.explanation = try values.decode(String.self, forKey: .explanation)
    self.hdurl = try values.decode(String.self, forKey: .hdurl)
    self.media_type = try values.decode(String.self, forKey: .media_type)
    self.service_version = try values.decode(String.self, forKey: .service_version)
    self.title = try values.decode(String.self, forKey: .title)
    self.url = try values.decode(String.self, forKey: .url)
    
    if let dateString = try? values.decode(String.self, forKey: .date),
      let date = DateFormatter.NASADate.date(from: dateString) {
      self.date = date
    } else {
      self.date = Date.distantPast
    }
  }
  
  fileprivate init() {
    self.date = DateFormatter.NASADate.date(from: "2020-01-25") ?? Date.distantPast
    self.explanation = "In this Hubble Space Telescope image the bright, spiky stars lie in the foreground toward the heroic northern constellation Perseus and well within our own Milky Way galaxy. In sharp focus beyond is UGC 2885, a giant spiral galaxy about 232 million light-years distant. Some 800,000 light-years across compared to the Milky Way's diameter of 100,000 light-years or so, it has around 1 trillion stars. That's about 10 times as many stars as the Milky Way. Part of a current investigation to understand how galaxies can grow to such enormous sizes, UGC 2885 was also part of astronomer Vera Rubin's pioneering study of the rotation of spiral galaxies. Her work was the first to convincingly demonstrate the dominating presence of dark matter in our universe."
    self.hdurl = "https://apod.nasa.gov/apod/image/2001/RubinsGalaxy_hst2000.jpg"
    self.media_type = "image"
    self.service_version = "v1"
    self.title = "Rubin's Galaxy"œ
    self.url = "https://apod.nasa.gov/apod/image/2001/RubinsGalaxy_hst1024.jpg"
  }
  
  public static func debugPreview() -> ImageOfTheDay {
    let preview = ImageOfTheDay()
    return preview
  }
  
  public func downloadImage( hd: Bool = true, completion: @escaping (UIImage?) -> Void) {
    guard let requestURL = URL(string: hd ? self.hdurl : self.url) else {
      print("Error creating requestURL")
      completion(nil)
      return
    }
    var request = URLRequest(url: requestURL)
    request.httpMethod = "GET"
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
      guard let imageData = data else {
        if let error = error {
          print("Error: \(error)")
        }
        completion(nil)
        return
      }
      
      if let uiImage = UIImage(data: imageData) {
        completion(uiImage)
        return
      } else {
        completion(nil)
        return
      }
      
    })
    task.resume()
  }
}

extension DateFormatter {
  static let NASADate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX") // Locale.current//
    formatter.timeZone = TimeZone(abbreviation: "UTC") // TimeZone.current//
    formatter.dateFormat = "YYYY-MM-DD"
    return formatter
  }()
}
