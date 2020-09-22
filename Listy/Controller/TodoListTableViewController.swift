//
//  TodoListTableViewController.swift
//  Listy
//
//  Created by Cielo on 17/09/2020.
//  Copyright © 2020 Osama. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    
    // MARK: Variables And Outlets
    
    var itemArray               = [Item]()
    static let arrayDefaultsID  = "ListyItemsArray.plist"
    let dataFilePath            = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(arrayDefaultsID)
    
    
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        setupData()
    }

}


// MARK: Private Methods

extension TodoListTableViewController {
    private func setupData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                let decoder = PropertyListDecoder()
                self.itemArray   = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Erorr while getting data, \(error)")
            }
            
        }
        
    }
    
    private func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array: \(error)")
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
            let newItem = Item()
            newItem.title = textFieldLocal.text!
            self.itemArray.append(newItem)
            self.saveData()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new note!"
            textFieldLocal = alertTextField
            print("Now")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
