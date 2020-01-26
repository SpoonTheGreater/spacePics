//
//  ImageOfTheDay.swift
//  SpacePics
//
//  Created by James Sadlier on 25/01/2020.
//  Copyright © 2020 jamSoft. All rights reserved.
//

import Foundation
import UIKit

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
    self.title = "Rubin's Galaxy"
    self.url = "https://apod.nasa.gov/apod/image/2001/RubinsGalaxy_hst1024.jpg"
  }
  
  public static func debugPreview() -> ImageOfTheDay {
    let preview = ImageOfTheDay()
    return preview
  }
  
  public func downloadImage( hd: Bool = false, completion: @escaping (UIImage?) -> Void) {
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
