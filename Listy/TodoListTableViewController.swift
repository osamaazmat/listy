//
//  TodoListTableViewController.swift
//  Listy
//
//  Created by Cielo on 17/09/2020.
//  Copyright © 2020 Osama. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Milk", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

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
        cell.textLabel?.text = itemArray[indexPath.item]
        
        return cell
    }
    
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }
        else {
            cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: Actions

extension TodoListTableViewController {
    
    @IBAction func onPressAddBtn(_ sender: Any) {
        
        var textFieldLocal = UITextField()
        
        let alert = UIAlertController(title: "Add a new Listy Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(textFieldLocal.text!)
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
