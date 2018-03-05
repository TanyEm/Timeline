//
//  TimelineData.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 27/02/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import Foundation
import SwiftyJSON

class TimelineData {

    var display_name: String?
    var username: String?
    var content: String?
    var avatar: String?
    var created_at: String?
    var id: String?

    func setFields(_ item: JSON) -> TimelineData {
        self.display_name = item["account"]["display_name"].string
        self.username = String("@\(String(describing: item["account"]["username"].string!))")

        // Parsing data for content, search and delete html tags
        self.content = item["content"].string?.replacingOccurrences(of: "<[^>]+>",
                                                      with: "",
                                                      options: String.CompareOptions.regularExpression,
                                                      range: nil)
        
        self.created_at = item["created_at"].string
        self.avatar = item["account"]["avatar_static"].string
        self.id = item["id"].string

        return self
    }
}
