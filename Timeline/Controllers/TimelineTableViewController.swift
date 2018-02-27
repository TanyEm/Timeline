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

    var timelineData = [TimelineData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let apiURL = URL(string: "https://mastodon.social/api/v1/timelines/public")
        Alamofire.request(apiURL!).responseJSON { (response) in
            let result = response.data
            let json = JSON(result!)
            for item in json.arrayValue {
                self.timelineData.append(TimelineData().setFields(item))
            }
            print(self.timelineData)
            self.tableView.reloadData()
        }

    }


    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

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
        cell.timeLabel.text = timeline.created_at

        if timeline.avatar != nil {
            cell.avatarImg.image = try! UIImage(data: Data(contentsOf: URL(string: timeline.avatar!)!))
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
        // Передать ID статуса
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
