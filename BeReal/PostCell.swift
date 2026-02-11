//
//  PostCell.swift
//  BeReal
//
//  Created by Bryan Puckett on 2/9/26.
//

import UIKit
import ParseSwift

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var imageTask: URLSessionDataTask?

    func configure(with post: Post) {
        // Username — use username from included user, fall back to "Unknown"
        if let username = post.user?.username, !username.isEmpty {
            usernameLabel.text = username
        } else {
            usernameLabel.text = "Unknown"
        }

        // Location and relative time (e.g. "San Francisco, SOMA · 2hr ago")
        var locationTimeParts = [String]()
        if let location = post.location, !location.isEmpty {
            locationTimeParts.append(location)
        }
        if let date = post.createdAt {
            locationTimeParts.append(relativeTimeString(from: date))
        }
        locationTimeLabel.text = locationTimeParts.isEmpty ? nil : locationTimeParts.joined(separator: " · ")

        // Caption
        captionLabel.text = post.caption

        // Date
        if let date = post.createdAt {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: date)
        }

        // Image - using URLSession instead of Alamofire
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            imageTask = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.postImageView.image = image
                }
            }
            imageTask?.resume()
        }
    }

    /// Returns a relative time string like "2hr ago", "3 days ago", "Just now"
    private func relativeTimeString(from date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)

        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)hr ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        locationTimeLabel.text = nil
        postImageView.image = nil
        captionLabel.text = nil
        dateLabel.text = nil
        imageTask?.cancel()
    }
}
