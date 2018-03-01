//
//  ViewController.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 26/02/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StatusViewController: UIViewController {

    var statusID = ""
    var statusData = [StatusData]()

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let apiURL = URL(string: "https://mastodon.social/api/v1/statuses/\(statusID)")
        Alamofire.request(apiURL!).responseJSON { (response) in
            let result = response.data
            let json = JSON(result!)
            for item in json.arrayValue {
                self.statusData.append(StatusData().setStatus(item))
            }
            let status: StatusData
            print(status.username)
            self.contentLabel.text = status.content
            self.nicknameLabel.text = status.username
            self.usernameLabel.text = status.display_name

            if status.avatar != nil {
                self.avatarImg.image = try! UIImage(data: Data(contentsOf: URL(string: status.avatar!)!))
                self.avatarImg.layer.cornerRadius = 70 / 2
                self.avatarImg.layer.borderWidth = 1.0
                self.avatarImg.layer.borderColor = UIColor.white.cgColor
                self.avatarImg.clipsToBounds = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

