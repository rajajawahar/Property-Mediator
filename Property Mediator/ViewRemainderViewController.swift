//
//  RemainderViewController.swift
//  Property Mediator
//
//  Created by Raja Mohamed on 27/07/17.
//  Copyright © 2017 sedintechnologies. All rights reserved.
//

import UIKit
import EventKit


class ViewRemainderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!

    @IBOutlet weak var remainderTableView: UITableView!
    @IBAction func backButtton(_ sender: Any) {
      _ = navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        self.automaticallyAdjustsScrollViewInsets = false
        self.remainderTableView.dataSource = self
        self.remainderTableView.delegate = self
        self.eventStore.requestAccess(to: EKEntityType.reminder, completion:{
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: {(
                    reminders: [EKReminder]?) -> Void in
                    DispatchQueue.main.async(execute: {
                        self.reminders = reminders
                        self.remainderTableView.reloadData()
                    })
                    
                })
            } else {
                DispatchQueue.main.async(execute: {
                    print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
                })
            }
        })
        self.remainderTableView.reloadData()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "RemainderTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RemainderTableViewCell
        let reminder:EKReminder! = self.reminders![indexPath.row]
        cell.remainderDescriptino.text = reminder.title
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dueDate = (reminder.dueDateComponents as NSDateComponents?)?.date{
            cell.remainderDate.text = formatter.string(from: dueDate)
        }else{
            cell.remainderDate.text = "N/A"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }




}
