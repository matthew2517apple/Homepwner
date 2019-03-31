//
//  ItemStore.swift
//  Homepwner
//
//  Created by MJC-iCloud on 2/22/19.
//  Copyright © 2019 Matthew. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    init() {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let archivedItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Item]
            allItems = archivedItems!
        } catch {
            print("error unarchiving \(error)")
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func saveChanges() -> Bool {
        do {
            print("Saving items to: \(itemArchiveURL)")
            let data = try NSKeyedArchiver.archivedData(withRootObject: allItems, requiringSecureCoding: false)
            try data.write(to: itemArchiveURL)
            return true
        } catch {
            return false
        }
    }
}
