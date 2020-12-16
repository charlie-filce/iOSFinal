//
//  ViewController.swift
//  FilceC_Final
//
//  Created by cpsc on 12/15/20.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "To-Do"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
        let alphButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(ViewController.didTapSortAlphButton(_:)))
        let dateButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.didTapSortDateButton(_:)))
        navigationItem.rightBarButtonItems = [addButton, alphButton, dateButton]
        //NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.UIApplication.didEnterBackgroundNotification, object: nil)
        
        do {
            self.todoItems = try [ToDoItem].readFromPersistence()
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found")
            } else {
                let alert = UIAlertController (
                    title: "Error",
                    message: "Could not load to-do items",
                    preferredStyle: .alert)
                    
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                NSLog("Error loading from persistence: \(error)")
            }
        }
    }
    
    
    private var todoItems = [ToDoItem]()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
        
        if indexPath.row < todoItems.count {
            let item = todoItems[indexPath.row]
            
            if item.detail != "" {
                if item.dueDate != "" {
                    cell.textLabel?.text = item.title + " Description: " + item.detail + " Date: " + item.dueDate
                } else {
                    cell.textLabel?.text = item.title + " Description: " + item.detail
                }
            } else {
                if item.dueDate != "" {
                    cell.textLabel?.text = item.title + " Date: " + item.dueDate
                } else {
                    cell.textLabel?.text = item.title
                }
            }
            
            
            let accessory: UITableViewCell.AccessoryType = item.done ? .checkmark : .none
            
            cell.accessoryType = accessory
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < todoItems.count {
            let item = todoItems[indexPath.row]
            item.done = !item.done
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func didTapAddItemButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController (
            title: "New to-do item",
            message: "Insert the title of the new to-do item",
            preferredStyle: .alert)
        
        alert.addTextField { (textField) in textField.placeholder = "Title"}
        alert.addTextField { (textField) in textField.placeholder = "Description"}
        alert.addTextField { (textField) in textField.placeholder = "Date"}
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text, let detail = alert.textFields?[1].text, let dueDate = alert.textFields?[2].text {
                self.addNewToDoItem(title: title, detail: detail, dueDate: dueDate)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapSortAlphButton(_ sender: UIBarButtonItem) {
        todoItems.sort(by: { $0.title < $1.title })
        tableView.reloadData()
    }
    
    @objc func didTapSortDateButton(_ sender: UIBarButtonItem) {
        todoItems.sort(by: { $0.dueDate < $1.dueDate })
        tableView.reloadData()
    }
    
    private func addNewToDoItem(title: String, detail: String, dueDate: String) {
        let newIndex = todoItems.count
        todoItems.append(ToDoItem(title: title, detail: detail, dueDate: dueDate))
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < todoItems.count {
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }


}

