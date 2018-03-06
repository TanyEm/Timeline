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

    var displayName: String?
    var username: String?
    var content: String?
    var avatar: String?
    var createdAt: String?
    var id: String?
    var previewUrl: String?
    var imageType: String?

    func setFields(_ item: JSON) -> TimelineData {
        self.displayName = item["account"]["display_name"].string

        if let usernameString = item["account"]["username"].string {
            self.username = String("@\(usernameString)")
        }

        // Parsing data for content, search and delete html tags
        self.content = item["content"].string?.replacingOccurrences(of: "<[^>]+>",
                                                      with: "",
                                                      options: String.CompareOptions.regularExpression,
                                                      range: nil)
        
        self.createdAt = item["created_at"].string?.dateFormat()?.timeAgoDisplay()
        self.avatar = item["account"]["avatar_static"].string
        self.id = item["id"].string

        self.imageType = item["media_attachments"][0]["type"].string
        self.previewUrl = item["media_attachments"][0]["preview_url"].string

        return self
    }
}
