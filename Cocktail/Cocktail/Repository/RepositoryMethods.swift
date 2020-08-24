//
//  RepositoryMethods.swift
//  Cocktail
//
//  Created by Jhennyfer Rodrigues de Oliveira on 20/08/20.
//  Copyright © 2020 Jhennyfer Rodrigues de Oliveira. All rights reserved.
//

import Foundation
protocol RepositoryMethods: class {
    associatedtype Item: RepositoryItem
    var items: [Item] { get set }
    func createNewItem() -> Item?
    func readAllItems() -> [Item]
    func readItem(id: UUID) -> Item?
    func update(item: Item)
    func delete(id: UUID)
}
extension RepositoryMethods {
    func createNewItem() -> Item? {
        let newRecipe = Item()
        //persist file
        if let data = try? JSONEncoder().encode(newRecipe) {
            FileHelper().createFile(with: data, name: newRecipe.identifier.uuidString)
            return newRecipe
        }
        return nil
    }
    func readAllItems() -> [Item] {
        //read the content of the documents path
        let fileNames: [String] = FileHelper().contentsForDirectory(atPath: "")
        //retrieve items from fileNames and update items array
        self.items = fileNames.compactMap { fileName in
            if let data = FileHelper().retrieveFile(at: fileName) {
                //decode from Data type to Item type
                let item = try? JSONDecoder().decode(Item.self, from: data)
                return item
            }
            return nil
        }
        return items
    }
    func readItem(id: UUID) -> Item? {
        //read one file by name. In our case, plant files are named with their id.uuidString.
        if let data = FileHelper().retrieveFile(at: id.uuidString) {
            //decode from Data type to Item type
            let item = try? JSONDecoder().decode(Item.self, from: data)
            return item
        }
        return nil
    }
    func update(item: Item) {
        //encode to Data format
        if let data = try? JSONEncoder().encode(item) {
            //overrite persisted file
            FileHelper().updateFile(at: item.identifier.uuidString, data: data)
        }
    }
    func delete(id: UUID) {
        FileHelper().removeFile(at: id.uuidString)
    }
}
