//
//  APIService.swift
//  Telstra
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import Foundation

enum MyError: Error {
  case network(Error)
  case malformedEndpoint
  case deserializing
  case unknown
}

class APIService {
  private let endpoint = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
  private var offset = 0
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func fetchContent(completionHandler: @escaping (Result<Content, MyError>) -> Void) {
    guard let url = URL(string: endpoint) else {
      return
    }
    
    // Set cache policy for the request to ignore cache data.
    // discussion: This resolves the issue on UI when it goes offline app keeps getting no network problem if user tries to reload data in a short time period. It works fine on physical devices (tested on iOS 13.3.1), and simulators with iOS lower than iOS 13. But the issue still happens on simulator with iOS 13 sometimes after few times of reloading. I tried session configuration solution but didn't get improvement. So leave it as a discussion here.
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 4)
    
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        return completionHandler(.failure(.network(error)))
      }
      
      guard let data = data,
        let dataString = String(data: data, encoding: .ascii) else {
          completionHandler(.failure(.deserializing))
          return
      }
      
      // Remove escape characters for JSONDecoder.
      let nonescapeString = String(dataString.filter{ !"\n".contains($0) && !"\t".contains($0) })
      
      guard  let nonescapeData = nonescapeString.data(using: .utf8),
        let content = try? JSONDecoder().decode(Content.self, from: nonescapeData) else {
          completionHandler(.failure(.deserializing))
          return
      }
      
      completionHandler(.success(content))
    }.resume()
  }
}
