//
//  TableViewController.swift
//  NotificationApp
//
//  Created by panxingyang on 10/20/19.
//  Copyright © 2019 Yun Lu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    let model = TaskModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
    }
       
    // MARK: - Table view data source

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController, let editTaskController = navController.children.first as? EditTaskViewController, let index = sender as? Int{
            editTaskController.task = model.tasks[index]
            editTaskController.TaskName.title =  model.tasks[index].title
//            editTaskController.task.date = model.tasks[index].date
//            editTaskController.TaskTitleField.text = model.tasks[index].title
//            editTaskController.TaskDatePicker.date = model.tasks[index].date
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        print("add new task!")
        self.performSegue(withIdentifier: "EditTask", sender: self)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if model.tasks.count == 0 {
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
        else {
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
        return model.tasks.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)

        // Configure the cell...
        let task = model.tasks[indexPath.row]
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        let titleAttr: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize: 25.0)]
        let titleStr = NSMutableAttributedString(string: task.title, attributes: titleAttr)
        let timeAttr: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize: 45.0)]
        let timeStr = NSMutableAttributedString(string: task.formattedTime, attributes: timeAttr)
        titleStr.addAttributes(titleAttr, range: NSMakeRange(0, titleStr.length))
        timeStr.addAttributes(timeAttr, range: NSMakeRange(0, timeStr.length-2))

        cell.textLabel?.attributedText = titleStr
        cell.detailTextLabel?.attributedText = timeStr
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
    // edit and delete actions
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let editTask = UISwipeActionsConfiguration(actions: edit)
//    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //edit perform segue
        let editTask = UITableViewRowAction(style: .normal, title: "Edit"){
            (action, indexPath) in
            self.performSegue(withIdentifier: "EditTask", sender: indexPath.row)
        }
        
        //delete
        let deleteTask = UITableViewRowAction(style: .destructive, title: "Delete"){
            (action, indexPath) in
            self.model.removeTask(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
        return [editTask,deleteTask]
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
