//
//  FormViewController.swift
//  Remind me later
//
//  Created by yun lu on 11/3/19.
//  Copyright © 2019 yun lu. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

protocol FormViewDelegate {
    func onAddOrEditSuccess()
}

class FormViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var newReminder = Reminder()
    var reminderListViewDelegate : FormViewDelegate?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var action : String = "Add"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = newReminder.title
        datePicker.date = newReminder.time ?? Date()
        datePicker.minimumDate = Date()
    }
    
    @IBAction func titleChanged(_ sender: UITextField) {
        newReminder.title = sender.text
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        newReminder.time = sender.date
    }
    
    @IBAction func AddPressed(_ sender: Any) {
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
        reminderListViewDelegate?.onAddOrEditSuccess()
        navigationController?.popViewController(animated: true)
        if action == "Add" {
            createNotification()
        } else {
            updateNotification()
        }
    }
    
    func createNotification(){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Remind Me Later"
        notificationContent.subtitle = newReminder.title ?? ""
        notificationContent.body = "Do it NOW!!!!"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newReminder.time!), repeats: false)
        
        let request = UNNotificationRequest(identifier: newReminder.id!.uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func updateNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [newReminder.id!.uuidString])
        createNotification()
    }
}
