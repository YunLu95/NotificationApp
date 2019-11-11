//
//  ViewController.swift
//  Remind me later
//
//  Created by yun lu on 11/3/19.
//  Copyright © 2019 yun lu. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ReminderListViewController: UITableViewController, FormViewDelegate {
        
    func onAddOrEditSuccess() {
        self.loadReminders()
        self.tableView.reloadData()
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var incompletedReminderArray = [Reminder]()
    var completedReminderArray = [Reminder]()
    
    
    var formViewDelegate : FormViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadReminders()
    }
    
    func loadReminders() {
        let sortDesc = NSSortDescriptor(key: "time", ascending: true)
        let request1 : NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request1.predicate = NSPredicate(format: "time > %@", Date() as NSDate)
        request1.sortDescriptors = [sortDesc]
        let request2 : NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request2.predicate = NSPredicate(format: "time <= %@", Date() as NSDate)
        request2.sortDescriptors = [sortDesc]
        do {
            try incompletedReminderArray = context.fetch(request1)
            try completedReminderArray = context.fetch(request2)
        }catch{
            print("Error fetching \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return incompletedReminderArray.count
        } else {
            return completedReminderArray.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["To Do", "Finished"][section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        if indexPath.section == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCellDisabled", for: indexPath)
            cell.textLabel?.text = completedReminderArray[indexPath.row].title!
            cell.detailTextLabel?.text = getFormattedDate(date: completedReminderArray[indexPath.row].time!)
        } else {
            cell.textLabel?.text = incompletedReminderArray[indexPath.row].title!
            cell.detailTextLabel?.text = getFormattedDate(date: incompletedReminderArray[indexPath.row].time!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTask = UIContextualAction(style: .destructive, title: "Delete") { (action, view, escaping) in
            if indexPath.section == 0{
                self.deleteNotification(id: self.incompletedReminderArray[indexPath.row].id!.uuidString)
                self.context.delete(self.incompletedReminderArray[indexPath.row])
                self.incompletedReminderArray.remove(at: indexPath.row)
            } else {
                self.context.delete(self.completedReminderArray[indexPath.row])
                self.completedReminderArray.remove(at: indexPath.row)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            do {
                try self.context.save()
            } catch {
                print("Error delete: \(error)")
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteTask])
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ListToAdd", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ListToEdit", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToEdit"{
            let itemToEdit = incompletedReminderArray[tableView.indexPathForSelectedRow!.row]
            let destiVC = segue.destination as! FormViewController
            destiVC.reminderListViewDelegate = self
            destiVC.newReminder = itemToEdit
            destiVC.action = "Edit"
        } else if segue.identifier == "ListToAdd" {
            let formVC : FormViewController = segue.destination as! FormViewController
            formVC.reminderListViewDelegate = self
            let newItem = Reminder(context: context)
            newItem.completed = false
            newItem.id = UUID()
            newItem.title = "New Reminder"
            newItem.time = Date()
            formVC.newReminder = newItem
        }
    }
    
    func getFormattedDate(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }
    
    func deleteNotification(id: String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
}
