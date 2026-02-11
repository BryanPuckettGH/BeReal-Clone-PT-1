//
//  FeedViewController.swift
//  BeReal
//
//  Created by Bryan Puckett on 2/9/26.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private let refreshControl = UIRefreshControl()

    private var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BeReal."
        tableView.dataSource = self
        tableView.allowsSelection = false

        // Pull-to-refresh
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
    }

    @objc private func onPullToRefresh() {
        queryPosts()
    }

    private func queryPosts() {
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .limit(10)

        query.find { [weak self] result in
            DispatchQueue.main.async {
                // End refreshing
                self?.refreshControl.endRefreshing()

                switch result {
                case .success(let posts):
                    self?.posts = posts
                case .failure(let error):
                    // If session token is invalid, trigger logout
                    if error.code == .invalidSessionToken {
                        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
                    } else {
                        self?.showAlert(description: error.localizedDescription)
                    }
                }
            }
        }
    }

    @IBAction func onLogoutTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }

    private func showAlert(description: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: description,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
