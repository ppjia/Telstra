//
//  Helper.swift
//  Telstra
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import UIKit

class Helper {
  
  // Draw a placeholder image with the text.
  static func placeholderImage(size: CGSize = CGSize(width: 60.0, height: 60.0)) -> UIImage? {
    return UIGraphicsImageRenderer(size: size).image { _ in
      "Image not found".draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
