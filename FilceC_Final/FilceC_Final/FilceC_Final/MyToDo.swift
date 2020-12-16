//
//  MyToDo.swift
//  FilceC_Final
//
//  Created by cpsc on 12/15/20.
//

import Foundation

class ToDoItem: NSObject, NSCoding {
    required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
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
    
    public init(title: String) {
        self.title = title
        self.done = false
    }
}

extension ToDoItem {
    public class func getMockData() -> [ToDoItem] {
        return [
            ToDoItem(title: "Milk"),
            ToDoItem(title: "Chocolate"),
            ToDoItem(title: "Bread"),
            ToDoItem(title: "Cheese")
        ]
    }
}

extension Collection where Iterator.Element == ToDoItem {
    private static func persistencePath() -> URL? {
        let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url?.appendingPathComponent("todoitems.bin")
    }
    
    func writeToPersistence() throws {
        if let url = Self.persistencePath(), let array = self as? NSArray {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
            try data.write(to: url)
        } else {
            throw NSError(domain: "com.example.MyToDo", code: 10, userInfo: nil)
        }
    }
    
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