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

    private let activityIndicator = UIActivityIndicatorView()
    private var timelineData = [TimelineData]()

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

        refreshControl?.addTarget(self,
                                  action: #selector(handleRefresh(refreshControl:)),
                                  for: .valueChanged)
        obtainTimeline()
    }

    override func viewDidLayoutSubviews() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = tableView.center
        activityIndicator.activityIndicatorViewStyle = .gray
        tableView.addSubview(activityIndicator)
    }

    @objc private func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...

        // Simply adding an object to the data source for this example
        obtainTimeline()
        refreshControl.endRefreshing()
    }

    func obtainTimeline() {
        guard let apiURL = URL(string: "https://mastodon.social/api/v1/timelines/public") else {
            return
        }

        activityIndicator.startAnimating()
        Alamofire.request(apiURL).responseJSON { [weak self] (response) in
            let result = response.data
            let json = JSON(result as Any)
            self?.timelineData = []
            for item in json.arrayValue {
                self?.timelineData.append(TimelineData().setFields(item))
            }
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timelineData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! UserStatusTableViewCell

        //getting the artist of selected position
        let timeline = timelineData[indexPath.row]

        //adding values to labels
        cell.usernameLabel.text = timeline.displayName
        cell.nicknameLabel.text = timeline.username
        cell.contentLabel.text = timeline.content

        cell.timeLabel.text = timeline.createdAt

        guard let avatarURL = timeline.avatar else {
            return cell
        }

        DispatchQueue.global(qos: .background).async {
            guard
                let url = URL(string: avatarURL),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                return
            }
            cell.avatarImage.image = image
        }
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let id = timelineData[indexPath.row].id,
            let statusViewController = segue.destination as? StatusViewController
         else { return }

        statusViewController.statusID = id
    }
}
