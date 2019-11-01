//
//  TaskModel.swift
//  NotificationApp
//
//  Created by panxingyang on 10/21/19.
//  Copyright © 2019 Yun Lu. All rights reserved.
//

import Foundation

struct Task {
    var title: String
    var date: Date
    var formattedTime: String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "h:mm a"
           return dateFormatter.string(from: self.date)
       }
}

class TaskModel{
    private(set) var tasks: [Task]
    
    init() {
        self.tasks = [
            Task(title: "First Task", date: Date()),
            Task(title: "Second Task", date: Date())
        ]
    }
    
    func removeTask (at index: Int ){
        tasks.remove(at: index)
    }
    
}

