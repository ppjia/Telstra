//
//  TelstraTests.swift
//  TelstraTests
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import XCTest
@testable import Telstra

class TelstraTests: XCTestCase {

    private var service: APIService?
    
    override func setUp() {
      let mockSession = MockSession(dataTaskWithRequestCalled: { [weak self] in
        (self?.loadSampleFileData(fileName: "stub"), nil, nil)
      })
      service = APIService(session: mockSession)
    }
    
    func testContentFetch() {
      service?.fetchContent { result in
        switch result {
          case let .success(content):
            XCTAssert(content.rows?.count == 14)
          default:
            XCTAssert(false)
        }
      }
    }
    
    func testContentViewModel() {
      guard let service = service else {
        fatalError("Couldn't start unit test!")
      }
      let viewModel = ContentViewModel(apiService: service)
      viewModel.fetchContent { isSuccess in
        XCTAssert(isSuccess)
        XCTAssert(viewModel.numberOfFeed == 13)
      }
    }
    
    private func loadSampleFileData(fileName: String) -> Data? {
      guard let sampleFilePath = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        return nil
      }
      return try? Data(contentsOf: sampleFilePath)
    }


}
