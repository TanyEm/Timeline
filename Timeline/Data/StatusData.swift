//
//  StatusData.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 27/02/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import Foundation
import SwiftyJSON

class StatusData{
    var display_name: String?
    var username: String?
    var content: String?
    var avatar: String?
    var created_at: String?

    func setStatus(_ item: JSON) -> StatusData {
        self.display_name = item["account"]["display_name"].string
        self.username = String("@\(String(describing: item["account"]["username"].string!))")
        self.content = item["content"].string
        self.created_at = item["created_at"].string
        self.avatar = item["account"]["avatar_static"].string

        return self
    }
}
