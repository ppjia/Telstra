//
//  FeedContentViewController.swift
//  Telstra
//
//  Created by ruixue on 22/4/20.
//  Copyright © 2020 jiarui. All rights reserved.
//

import UIKit


enum ViewConstants {
  enum TableCell {
    static let vPadding: CGFloat = 10.0
    static let hPadding: CGFloat = 10.0
    static let imageSize: CGFloat = 60.0
    static let fontSize: CGFloat = 18
  }
  enum TableView {
    static let cellIdentifier = "cellIdentifier"
    static let estimatedRowHeight: CGFloat = 60.0
  }
}

class FeedContentViewController: UIViewController {
  
  private let viewModel = ContentViewModel(apiService: APIService())
  
  private var allConstraints: [NSLayoutConstraint] = []
  
  private let refreshControl = UIRefreshControl()
  
  private var tableView: UITableView = {
    let tableView = UITableView()
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = ViewConstants.TableView.estimatedRowHeight
    tableView.rowHeight = UITableView.automaticDimension
    tableView.backgroundColor = .white
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    tableView.separatorColor = .darkGray
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
  private var loadingIndicator: UIActivityIndicatorView = {
    let loadingIndicator = UIActivityIndicatorView(style: .gray)
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = .gray
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    return loadingIndicator
  }()
  
  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white
    
    view.addSubview(tableView)
    view.addSubview(loadingIndicator)
    
    self.view = view
  }
  
  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    
    if !allConstraints.isEmpty {
      NSLayoutConstraint.deactivate(allConstraints)
      allConstraints.removeAll()
    }
    
    setupConstraints()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl.addTarget(self, action: #selector(fetchFeedContent), for: .valueChanged)
    tableView.refreshControl = refreshControl
    tableView.register(FeedTableCell.self, forCellReuseIdentifier: ViewConstants.TableView.cellIdentifier)
    tableView.dataSource = self
    
    fetchFeedContent()
  }
  
}

private extension FeedContentViewController {
  
  func setupConstraints() {
    let padding: CGFloat = 0.0
    let newInsets = view.safeAreaInsets
    let leftMargin = newInsets.left > 0 ? newInsets.left : padding
    let rightMargin = newInsets.right > 0 ? newInsets.right : padding
    let topMargin = newInsets.top > 0 ? newInsets.top : padding
    let bottomMargin = newInsets.bottom > 0 ? newInsets.bottom : padding
    
    let tableLeftConstraint = tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftMargin)
    let tableRightConstraint = tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -rightMargin)
    let tableTopConstraint = tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topMargin)
    let tableBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomMargin)
    let indicatorHorizontalConstraint = loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    let indicatorVerticalConstraint = loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    
    allConstraints.append(contentsOf: [
      tableLeftConstraint,
      tableRightConstraint,
      tableTopConstraint,
      tableBottomConstraint,
      indicatorVerticalConstraint,
      indicatorHorizontalConstraint
    ])
    
    NSLayoutConstraint.activate(allConstraints)
  }
  
  @objc func fetchFeedContent() {
    loadingIndicator.startAnimating()
    viewModel.fetchContent { [weak self] isSuccessful in
      DispatchQueue.main.async {
        guard let self = self else {
          return
        }
        self.loadingIndicator.stopAnimating()
        self.refreshControl.endRefreshing()
        
        if isSuccessful {
          self.title = self.viewModel.title
          self.tableView.reloadData()
        } else {
          self.showAlert()
        }
      }
    }
  }
  
  func showAlert() {
    let alert = UIAlertController(
      title: Constants.Message.dataLoadingErrorTitle,
      message: Constants.Message.dataLoadingErrorDescription,
      preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] action in
      self?.fetchFeedContent()
    })
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource
extension FeedContentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfFeed
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ViewConstants.TableView.cellIdentifier,
                                             for: indexPath) as! FeedTableCell
    cell.viewModel = viewModel.feedViewModel(at: indexPath.item)
    return cell;
  }
}
