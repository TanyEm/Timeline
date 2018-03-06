//
//  String.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 05/03/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import Foundation

extension String {
    
    /// It formating String similar to "2018-03-02T13:50:46.708Z" to Date format
    ///
    /// - Returns: Date
    func dateFormat() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        return dateFormatter.date(from: self)
    }
}
