//
//  FeedViewModel.swift
//  Telstra
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import Foundation

class FeedViewModel {
  private let feed: Feed
  
  var title: String {
    return feed.title ?? ""
  }
  
  var description: String? {
    return feed.description
  }
  
  var imageUrl: URL? {
    guard let urlString = feed.imageHref else {
      return nil
    }
    return URL(string: urlString)
  }
  
  init?(feed: Feed) {
    
    // Do not create feedViewModel for feed without title.
    guard let _ = feed.title else {
      return nil
    }
    self.feed = feed
  }
}
