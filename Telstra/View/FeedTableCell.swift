//
//  FeedTableCell.swift
//  Telstra
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import UIKit
import AlamofireImage

class FeedTableCell: UITableViewCell {
  private let feedContentView = TableCellView()
  private let placeholderImage = Helper.placeholderImage()
  
  var viewModel: FeedViewModel? {
    didSet {
      setupCell()
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(feedContentView)
    
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension FeedTableCell {
  func setupCell() {
    feedContentView.translatesAutoresizingMaskIntoConstraints = false
    
    feedContentView.titleLabel.text = viewModel?.title
    feedContentView.descriptionLabel.text = viewModel?.description
    
    guard let imageUrl = viewModel?.imageUrl else {
      feedContentView.imageSize = 0.0
      return
    }
    feedContentView.imageView.image = nil
    
    // Use AlamofireImage to load image.
    feedContentView.imageView.af.setImage(
      withURL: imageUrl,
      placeholderImage: placeholderImage)
    feedContentView.imageSize = ViewConstants.TableCell.imageSize
  }
  
  func setupConstraints() {
    feedContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    feedContentView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    feedContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    feedContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
  }
}

private class TableCellView: UIView {
  private var imageViewConstraints: [NSLayoutConstraint] = []
  
  var imageSize: CGFloat = 0.0 {
    didSet {
      setNeedsUpdateConstraints()
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: ViewConstants.TableCell.fontSize)
    label.numberOfLines = 0
    label.sizeToFit()
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.sizeToFit()
    return label
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  init() {
    super.init(frame: .zero)
    
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    addSubview(imageView)
    
    setupImageViewConstraints()
    setupBasicConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    setupImageViewConstraints()
    super.updateConstraints()
  }
}

private extension TableCellView {
  
  func setupBasicConstraints() {
    titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewConstants.TableCell.hPadding).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -ViewConstants.TableCell.hPadding).isActive = true
    titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConstants.TableCell.vPadding).isActive = true
    descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
    descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewConstants.TableCell.vPadding).isActive = true
    descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -ViewConstants.TableCell.vPadding).isActive = true

  }
  
  func setupImageViewConstraints() {
    if !imageViewConstraints.isEmpty {
      NSLayoutConstraint.deactivate(imageViewConstraints)
      imageViewConstraints.removeAll()
    }
    
    let trailingPadding: CGFloat = imageSize == 0.0 ? 0.0 : 10.0
    let imagetrailingConstraint = imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -trailingPadding)
    let imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageSize)
    let imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize)
    let imageTopConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConstants.TableCell.vPadding)
    let imageBottomConstraint = imageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -ViewConstants.TableCell.vPadding)
    imageBottomConstraint.priority = UILayoutPriority(rawValue: 750)
    
    imageViewConstraints.append(contentsOf: [
      imagetrailingConstraint,
      imageWidthConstraint,
      imageHeightConstraint,
      imageTopConstraint,
      imageBottomConstraint
    ])
    
    NSLayoutConstraint.activate(imageViewConstraints)
  }
}
