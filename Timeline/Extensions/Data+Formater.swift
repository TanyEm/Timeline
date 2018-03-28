//
//  Data.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 05/03/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import Foundation

extension Date {

    /// It return date how date ago
    ///
    /// - Returns: String
    func timeAgoDisplay() -> String {
        let secondsAgo = Int64(Date().timeIntervalSince(self))
        let minute: Int64 = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        }

        else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        }
        else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        }
        else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        return "\(secondsAgo / week) weeks ago"
    }
}
