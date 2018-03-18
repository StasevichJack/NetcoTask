//
//  MainViewController.swift
//  NetcoTask
//
//  Created by Jack on 3/18/18.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    // MARK: - Outlets.

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties.
    
    enum Section: Int {
        case Users
        case Loading
        
        init?(indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)
        }
        static var numberOfSections: Int { return 2 }
    }
    
    var user_id: Int = 0
    var isUpdating: Bool = false
    var isLastPage: Bool = false
    var isShowingFooterIndicator: Bool = true
    let refreshControl = UIRefreshControl()
    
    // MARK: - Default functions.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDefaults()
    }
    
}

// MARK: - Private functions.

extension MainViewController {
    
    private func configureDefaults() {
        
        // Table view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib.init(nibName: UserCell.className, bundle: nil), forCellReuseIdentifier: UserCell.className)
        self.tableView.register(UINib(nibName: LoadingCell.className, bundle: nil), forCellReuseIdentifier: LoadingCell.className)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        self.refreshControl.addTarget(self, action: #selector(self.updateData), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        
        // Update data.
        self.updateData()
    }
    
    @objc private func updateData() {
        self.isLastPage = false
        self.isUpdating = false
        self.user_id = 0
        
        self.getUsers()
    }
    
    private func getUsers() {
        
        if self.isLastPage || self.isUpdating {
            return
        }
        
        var user_id = 0
        let lastUser = User.getUsers()?.last
        if lastUser != nil, self.user_id != 0 {
            user_id = Int(lastUser?.user_id ?? 0)
        }
        
        LoadManager.sharedInstance.getUsers(user_id: user_id) { (success, result, message) in
            self.refreshControl.endRefreshing()
            if success {
                let resultsArray = result as! [User]
                self.isLastPage = resultsArray.count < 30 ? true : false
                self.isShowingFooterIndicator = !self.isLastPage
            } else {
                // Show error alert.
                Constants.showAlert(title: "Error", message: message ?? "Some error")
                self.isShowingFooterIndicator = false
            }
            self.tableView.reloadData()
            self.isUpdating = false
        }
        self.user_id = Int(lastUser?.user_id ?? 0)
        self.isUpdating = true
    }
}

// MARK: - UITableViewDataSource.

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section(rawValue: section)! {
        case .Users:
            return User.getUsersCount()
        case .Loading:
            return self.isShowingFooterIndicator ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Section(indexPath: indexPath)! {
        case .Users:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.className, for: indexPath) as? UserCell
            let user = User.getUserAtIndex(indexPath.row)
            cell?.user = user
            return cell!
        case .Loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.className, for: indexPath) as? LoadingCell
            cell?.activityIndicator.startAnimating()
            return cell!
        }
    }
}

// MARK: - UITableViewDelegate.

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.section != Section.Users.rawValue {
            return
        }
        if indexPath.row == User.getUsersCount() - 1 {
            self.getUsers()
        }
    }
}

