//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Labe on 2024/6/15.
//

import Foundation

struct ToDoItem: Codable {
    var title: String
    var content: [Content]
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func save(item: [Self]) {
        guard let data = try? JSONEncoder().encode(item) else { return }
        let url = documentsDirectory.appendingPathComponent("item")
        try? data.write(to: url)
    }
    
    static func load() -> [Self]? {
        let url = documentsDirectory.appendingPathComponent("item")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([Self].self, from: data)
    }
}

struct Content: Codable {
    var details: String
    var isFinish: Bool
}
