//
//  TimelineData.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 27/02/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TimelineData {

//    let apiURL = URL(string: "https://mastodon.social/api/v1/timelines/public")

    var display_name: String?
    var username: String?
    var content: String?
    var avatar: String?
    var created_at: String?

//    guard let url = URL(string: apiURL) else { return }
//    let json = JSON(data: url)
    static let currentTimeline = TimelineData()

    func setStatus(_ json: JSON) {
        self.display_name = json["account"]["display_name"].string
        self.username = json["account"]["username"].string
        self.content = json["content"].string
        self.created_at = json["created_at"].string

        let image = json["account"]["avatar"].dictionary
        let imageData = image?["data"]?.dictionary
        self.avatar = imageData?["url"]?.string
    }

//    init(display_name: String?, username: String?, content: String?, avatar: String?, created_at: String?){
//        self.display_name = display_name
//        self.username = username
//        self.avatar = avatar
//        self.created_at = created_at
//        self.content = content
//    }

}
