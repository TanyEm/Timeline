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
            do{
//                self.timelineData = try JSONDecoder().decode([TimelineData].self, from: result!)
//                for timeline in self.timelineData{
//
//
//                }
                let json = JSON(result!)
                //print(json)
                TimelineData.currentTimeline.setStatus(json)
            } catch {
                print(error)
            }
        }
        
        print(timelineData)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...


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
