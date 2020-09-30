//
//  TodoListTableViewController.swift
//  Listy
//
//  Created by Cielo on 17/09/2020.
//  Copyright © 2020 Osama. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    
    
    // MARK: Variables And Outlets
    
    var itemArray               = [Item]()
    static let arrayDefaultsID  = "ListyItemsArray.plist"
    let dataFilePath            = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(arrayDefaultsID)
    let context                 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        loadItems()
    }

}


// MARK: Private Methods

extension TodoListTableViewController {
   
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error while fetching Request")
        }
        tableView.reloadData()
    }
    
    private func saveData() {
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
    }
}


// MARK: Table View

extension TodoListTableViewController {
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text    = itemArray[indexPath.item].title
        cell.accessoryType      = itemArray[indexPath.item].isDone ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.item].isDone = !itemArray[indexPath.item].isDone
        self.saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}


// MARK: Actions

extension TodoListTableViewController {
    
    @IBAction func onPressAddBtn(_ sender: Any) {
        
        var textFieldLocal = UITextField()
        
        let alert = UIAlertController(title: "Add a new Listy Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(textFieldLocal.text!)
            let newItem     = Item(context: self.context)
            newItem.title   = textFieldLocal.text!
            newItem.isDone  = false
            
            self.itemArray.append(newItem)
            self.saveData()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new note!"
            textFieldLocal = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}


// MARK: Search Bar Delegate

extension TodoListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
