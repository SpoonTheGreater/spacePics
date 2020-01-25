//
//  NASAServices.swift
//  SpacePics
//
//  Created by James Sadlier on 25/01/2020.
//  Copyright © 2020 jamSoft. All rights reserved.
//

import Foundation

public class NASAServices {
  
  private static let TEST_API_KEY = "DEMO_KEY"
  
  public static let requestString = "https://api.nasa.gov/planetary/apod?api_key=\(NASAServices.TEST_API_KEY)"
  
  public static func getImageOfTheDay( completion: @escaping (ImageOfTheDay?) -> Void) {
    guard let requestURL = URL(string: NASAServices.requestString) else {
      print("Error creating requestURL")
      completion(nil)
      return
    }
    var request = URLRequest(url: requestURL)
    request.httpMethod = "GET"
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in

      sleep(3)

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

extension DateFormatter {
  static let NASADate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX") // Locale.current//
    formatter.timeZone = TimeZone(abbreviation: "UTC") // TimeZone.current//
    formatter.dateFormat = "YYYY-MM-DD"
    return formatter
  }()
}
