//
//  Feed.swift
//  Telstra
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import Foundation

struct Content: Codable {
  let title: String
  let rows: Array<Feed>?
}

struct Feed: Codable {
  let title: String?
  let description: String?
  let imageHref: String?
}
