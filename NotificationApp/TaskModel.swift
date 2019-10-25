//
//  TaskModel.swift
//  NotificationApp
//
//  Created by panxingyang on 10/21/19.
//  Copyright © 2019 Yun Lu. All rights reserved.
//

import Foundation

class TaskModel{
    private(set) var tasks: [Task]
    
    init() {
        self.tasks = [
            Task(title: "First Task", time: 3),
            Task(title: "Second Task", time: 5)
        ]
    }
    
    func removeTask (at index: Int ){
        tasks.remove(at: index)
    }
    
}

struct Task {
    let title: String
    let time: Int
    
}
