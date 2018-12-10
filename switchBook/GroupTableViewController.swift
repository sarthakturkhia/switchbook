//
//  GroupTableViewController.swift
//  SwitchBook
//
//  Created by applemac on 12/2/18.
//  Copyright © 2018 AllenShi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import UserNotifications

class GroupTableViewController: UITableViewController {
    
//    var groups = ["Family", "Friends", "Club"];
    
    @IBOutlet weak var addGroup: UIBarButtonItem!
    
    var groups : [String] = []
    var groupID = String()
    var ref: DatabaseReference!
    var members : [String] = []
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var groupName = cell.textLabel?.text
        groupName = groups[indexPath.row]
        
        let groupData = ref.child("users").ref.childByAutoId()
        
        
        //TODO: ADD Intial Notficiation Date Here AS Date not timestamp
        groupData.setValue(["members": "", "name": groupName, "date": Date().timeIntervalSince1970])
            // ServerValue.timestamp()]
        
        groupID = groupData.key!
        
//        if email account is created in Auth {
//              if email is already in members {
//                  error {
//                  print("Member already in group")
//                  return }
//              } else {
//                  add email to the group
//        groupData.updateChildValues(["members" : mem])
//        } else {
//                  error {
//                  print("Email does not exist")
//                  return }
//    }
        
        groupData.updateChildValues(["members" : members])
        
        sendNotification(Date: Date())
        return cell
    }
    // Sends notifications to prompt user to open the app
    func sendNotification(Date: Date){
        let content = UNMutableNotificationContent()
        content.title = "You have been matched!"
        content.body = "Open the app to see details of the recipient reader."
        content.sound = UNNotificationSound.default
        
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: Date)
        components.month = Calendar.current.component(.month, from: Date)
        components.day = Calendar.current.component((.day), from: Date)
        components.hour = Calendar.current.component(.hour, from: Date)
        components.minute = Calendar.current.component(.minute, from: Date) + 1
        
        
        let tigger = UNCalendarNotificationTrigger(dateMatching: components , repeats: true)
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: tigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Create a variable that you want to send
        var gID = groupID
        
        // Create a new variable to store the instance
        let destinationVC : SignViewController = segue.destination as! SignViewController
        destinationVC.groupID = [gID]
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "groupDetail", sender: self)
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
// field boolean - either matched or not matched group ID in members make that a key - the email value will be true or false - whether it chosen or not - true is when its chosen -
