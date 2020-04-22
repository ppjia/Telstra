//
//  ContentViewModel.swift
//  Telstra
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import Foundation

class ContentViewModel {
  private let apiService: APIService
  
  private var content: Content?
  private var feedViewModelList: Array<FeedViewModel>?
  
  var title: String {
    guard let content = content else {
      return ""
    }
    return content.title
  }
  
  var numberOfFeed: Int {
    guard let feedViewModelList = feedViewModelList else {
      return 0
    }
    return feedViewModelList.count
  }
  
  func feedViewModel(at index: Int) -> FeedViewModel? {
    return feedViewModelList?[safeIndex: index]
  }
  
  init(apiService: APIService) {
    self.apiService = apiService
  }
  
}

extension ContentViewModel {
  
  // Fetch feed content, return true is succeed, otherwise return false.
  func fetchContent(completion: @escaping (Bool) -> Void) {
    apiService.fetchContent { [weak self] result in
      guard let self = self else {
        return
      }
      
      switch result {
        case .success(let content):
          self.content = content
          
          // Filter out nil feedViewModel.
          self.feedViewModelList = content.rows?.compactMap { FeedViewModel(feed: $0) }.compactMap { $0 }
          completion(true)
        case .failure(_):
          completion(false)
      }
    }
  }
}
