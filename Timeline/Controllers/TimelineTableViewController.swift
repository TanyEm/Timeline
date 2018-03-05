//
//  TableViewController.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 27/02/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TimelineTableViewController: UITableViewController {

    let activityLoader = UIActivityIndicatorView()
    var timelineData = [TimelineData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        activityLoader.hidesWhenStopped = true
        activityLoader.center = tableView.center
        activityLoader.activityIndicatorViewStyle = .gray
        activityLoader.startAnimating()
        tableView.addSubview(activityLoader)

        let apiURL = URL(string: "https://mastodon.social/api/v1/timelines/public")
        
        Alamofire.request(apiURL!).responseJSON { (response) in
            let result = response.data
            let json = JSON(result!)
            for item in json.arrayValue {
                self.timelineData.append(TimelineData().setFields(item))
            }
            self.activityLoader.stopAnimating()
            self.tableView.reloadData()
        }

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timelineData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! UserStatusTableViewCell

        // Configure the cell...
        //the artist object
        let timeline: TimelineData

        //getting the artist of selected position
        timeline = timelineData[indexPath.row]

        //adding values to labels
        cell.usernameLabel.text = timeline.display_name
        cell.nicknameLabel.text = timeline.username
        cell.contentLabel.text = timeline.content

        let date = timeline.created_at?.dateFormat().timeAgoDisplay()
        cell.timeLabel.text = String(describing: date ?? "")

        if timeline.avatar != nil {
            cell.avatarImg.image = try! UIImage(data: Data(contentsOf: URL(string: timeline.avatar ?? "")!))
            cell.avatarImg.layer.cornerRadius = 70 / 2
            cell.avatarImg.layer.borderWidth = 1.0
            cell.avatarImg.layer.borderColor = UIColor.white.cgColor
            cell.avatarImg.clipsToBounds = true
        }

        return cell

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedStatus: TimelineData
            selectedStatus = timelineData[indexPath.row]
            let statusVC = segue.destination as! StatusViewController
            statusVC.statusID = selectedStatus.id!
        }
    }
}

extension String {
    /// It formating String similar to "2018-03-02T13:50:46.708Z" to Date format
    ///
    /// - Returns: Date
    func dateFormat() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        //        let dateObj = dateFormatter.date(from: timeline.created_at!)
        return dateFormatter.date(from: self)!
    }
}

extension Date {

    /// It returne date how date ago
    ///
    /// - Returns: String
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        }

        else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        }
        else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        }
        else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        return "\(secondsAgo / week) weeks ago"
    }
}
