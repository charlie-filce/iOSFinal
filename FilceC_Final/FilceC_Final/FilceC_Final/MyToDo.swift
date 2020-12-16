//
//  MyToDo.swift
//  FilceC_Final
//
//  Created by cpsc on 12/15/20.
//

import Foundation

class ToDoItem: NSObject, NSCoding {
    //decode the variables used in each todo item
    required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        } else {
            return nil
        }
        
        if let detail = aDecoder.decodeObject(forKey: "detail") as? String {
            self.detail = detail
        } else {
            return nil
        }
        
        if let dueDate = aDecoder.decodeObject(forKey: "dueDate") as? String {
            self.dueDate = dueDate
        } else {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "done") {
            self.done = aDecoder.decodeBool(forKey: "done")
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.done, forKey: "done")
    }
    
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

extension Collection where Iterator.Element == ToDoItem {
    private static func persistencePath() -> URL? {
        let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url?.appendingPathComponent("todoitems.bin")
    }
    
    //saving doesn't work, but this should write the to do list to persistence
    func writeToPersistence() throws {
        if let url = Self.persistencePath(), let array = self as? NSArray {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
            try data.write(to: url)
        } else {
            throw NSError(domain: "com.example.MyToDo", code: 10, userInfo: nil)
        }
    }
    
    //this should read the list from persistence
    static func readFromPersistence() throws -> [ToDoItem] {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?) {
            if let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [ToDoItem] {
                return array
            } else {
                throw NSError(domain: "com.example.MyToDo", code: 11, userInfo: nil)
            }
        } else {
            throw NSError(domain: "com.example.MyToDo", code: 12, userInfo: nil)
        }
    }
}
