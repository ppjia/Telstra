//
//  MockSession.swift
//  TelstraTests
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import Foundation

class MockDataTask: URLSessionDataTask {
  private let closure: () -> Void
  
  init(closure: @escaping () -> Void) {
    self.closure = closure
  }
  
  override func resume() {
    closure()
  }
}

class MockSession: URLSession {
  typealias DataTaskWithRequestCalled = (() -> (data: Data?, response: URLResponse?, error: Error?))
  private var dataTaskWithRequestCalled: DataTaskWithRequestCalled
  
  init(dataTaskWithRequestCalled: @escaping DataTaskWithRequestCalled) {
    self.dataTaskWithRequestCalled = dataTaskWithRequestCalled
  }
  
  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let (data, response, error) = dataTaskWithRequestCalled()
    return MockDataTask(closure: {
      completionHandler(data, response, error)
    })
  }
}
