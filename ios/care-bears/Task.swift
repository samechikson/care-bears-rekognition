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
    
    func calcColor() {
        // one day in seconds = 86400
        let fraction = (self.timeLeft / 86400)
        let index = Int((fraction * 5).rounded(.down))
        self.color = possibleColors[index]
    }
    
    
}
