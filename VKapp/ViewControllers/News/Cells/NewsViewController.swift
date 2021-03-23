//
//  NewsViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.03.2021.
//

import UIKit

final class NewsViewController: UIViewController {
  @IBOutlet private var backgroundView: GradientView! {
    didSet {
    }
  }
  @IBOutlet private weak var newsTableView: UITableView! {
    didSet {
      self.newsTableView.delegate = self
      self.newsTableView.dataSource = self
      self.newsTableView.backgroundColor = Constants.newsTableViewBackgroundColor
      self.newsTableView.register(Constants.newsPostCellNib, forCellReuseIdentifier: Constants.newsPostCellId)
//      self.newsTableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - TableView Datasource
extension NewsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants
                                  .newsPostCellId) as? NewsPostTableViewCell
    else { return UITableViewCell() }
    let ipath: String = "\(indexPath.row + 1)"
    cell.configureHeader(UIImage(named: "photo\(ipath)")!,
                         "CellForRow\(ipath)",
                         "Common testing")
    cell.configureFooter("\(ipath)",
                         "\(ipath)",
                         "\(ipath)",
                         "\(ipath)")
    var text: String?
    var photo: UIImage?
    switch (indexPath.row + 1) % 3 {
    case 0:
      text = "CEEEEELLLLL NUMBER\(ipath)"
    case 1:
      text = "CELL WITH PHOOOTOO\(ipath)"
      photo = UIImage(named: "photo\(ipath)")
    default:
      photo = UIImage(named: "photo\(ipath)")
    }
    cell.configureContent(text,
                          photo)
    return cell
  }
}

// MARK: - TableView Delegate
extension NewsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    #if DEBUG
    print("Selected row is \(indexPath.row)")
    #endif
  }
}
