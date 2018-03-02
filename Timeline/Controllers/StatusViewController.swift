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

    // Getted from TimelineTVC
    var statusID = ""
    var statusData = TimelineData()

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(statusID)
        let apiURL = URL(string: "https://mastodon.social/api/v1/statuses/\(statusID)")
        Alamofire.request(apiURL!).responseJSON { (response) in
            let result = response.data
            let json = JSON(result!) 
            self.statusData = TimelineData().setFields(json)
            self.setData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Adding data in view
    func setData() {
        contentLabel.text = self.statusData.content
        nicknameLabel.text = self.statusData.username
        usernameLabel.text = self.statusData.display_name

        if self.statusData.avatar != nil {
            avatarImg.image = try! UIImage(data: Data(contentsOf: URL(string: self.statusData.avatar!)!))
            avatarImg.layer.cornerRadius = 70 / 2
            avatarImg.layer.borderWidth = 1.0
            avatarImg.layer.borderColor = UIColor.white.cgColor
            avatarImg.clipsToBounds = true
        }
    }

}

