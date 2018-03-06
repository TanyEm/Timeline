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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        // iOS not collapsing large navbar workaround
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        activityLoader.hidesWhenStopped = true
        activityLoader.center = tableView.center
        activityLoader.activityIndicatorViewStyle = .gray
        activityLoader.startAnimating()
        tableView.addSubview(activityLoader)

        self.refreshControl?.addTarget(self,
                                       action: #selector(TimelineTableViewController.handleRefresh(refreshControl:)),
                                       for: UIControlEvents.valueChanged)
        parsJSON()
    }

    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...

        // Simply adding an object to the data source for this example
        parsJSON()
        refreshControl.endRefreshing()
    }

    func parsJSON() {
        if let apiURL = URL(string: "https://mastodon.social/api/v1/timelines/public") {
            Alamofire.request(apiURL).responseJSON { (response) in
                let result = response.data
                let json = JSON(result as Any)
                self.timelineData = []
                for item in json.arrayValue {
                    self.timelineData.append(TimelineData().setFields(item))
                }
                if self.activityLoader.isAnimating {
                    self.activityLoader.stopAnimating()
                }
                self.tableView.reloadData()
            }
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
        cell.usernameLabel.text = timeline.displayName
        cell.nicknameLabel.text = timeline.username
        cell.contentLabel.text = timeline.content

//        let date = timeline.created_at?.dateFormat()?.timeAgoDisplay()
        cell.timeLabel.text = timeline.createdAt

        if let avatarURL = timeline.avatar,
            let url = URL(string: avatarURL),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data){
            cell.avatarImg.image = image
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
            let statusVC = segue.destination as? StatusViewController
            if let id = selectedStatus.id {
                statusVC?.statusID = id
            }
        }
    }
}
