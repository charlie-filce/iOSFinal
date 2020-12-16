//
//  MyToDo.swift
//  FilceC_Final
//
//  Created by cpsc on 12/15/20.
//

import Foundation

class ToDoItem: Codable {
    var title: String
    var done: Bool
    var detail: String
    var dueDate: String //I couldn't get date variables working
    
    public init(title: String, detail: String, dueDate: String) {
        self.title = title
        self.detail = detail
        self.dueDate = dueDate
        self.done = false
    }
}

//mock data used for initial testing of layout
extension ToDoItem {
    public class func getMockData() -> [ToDoItem] {
        return [
            ToDoItem(title: "Milk",detail: "",dueDate: ""),
            ToDoItem(title: "Chocolate",detail: "",dueDate: ""),
            ToDoItem(title: "Bread",detail: "",dueDate: ""),
            ToDoItem(title: "Cheese",detail: "",dueDate: "")
        ]
    }
}
