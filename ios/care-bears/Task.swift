//
//  Task.swift
//  care-bears
//
//  Created by Samuel Echikson on 12/26/18.
//  Copyright © 2018 Samuel Echikson. All rights reserved.
//

import UIKit

class Task {
    var title: String = ""
    var timeLeft: TimeInterval = 86400
    var dueDate: Date!
    var color: UIColor!
    
    var possibleColors: [UIColor] = [
        UIColor(red: 94/255, green: 199/255, blue: 175/255, alpha: 1),
        UIColor(red: 186/255, green: 225/255, blue: 148/255, alpha: 1),
        UIColor(red: 232/255, green: 242/255, blue: 85/255, alpha: 1),
        UIColor(red: 221/255, green: 171/255, blue: 79/255, alpha: 1),
        UIColor(red: 203/255, green: 106/255, blue: 67/255, alpha: 1)
    ]
    
    init(title: String, timeLeft: TimeInterval) {
        self.title = title
        self.timeLeft = timeLeft
        self.calcColor()
    }
    
    init(title: String, dueDate: Date) {
        self.title = title
        self.dueDate = dueDate
        
        self.timeLeft = dueDate.timeIntervalSinceNow
        self.calcColor()
    }
    
    init?(json: [String: Any]) {
        print(json)
        guard let title = json["name"] as? String,
            let targetTime = DateFormatter().date(fromISOString: json["time_targeted_first"] as! String)
            else {
                return nil
        }
        
        self.title = title
        self.dueDate = targetTime
        self.timeLeft = -targetTime.timeIntervalSinceNow
        self.calcColor()
    }
    
    func calcColor() {
        // one day in seconds = 86400
        print(self.timeLeft)
        let fraction = ((86400 - self.timeLeft) / 86400)
        var index = Int((fraction * 5).rounded(.down))
        if index > 4 { index = 4 }
        if index < 0 { index = 0 }
        print(index)
        self.color = possibleColors[index]
    }
    
    
}

extension DateFormatter {
    func date(fromISOString dateString: String) -> Date? {
        // Dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
}

