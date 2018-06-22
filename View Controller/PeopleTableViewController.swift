//
//  PeopleTableViewController.swift
//  People Pairer
//
//  Created by Justin Trautman on 6/22/18.
//  Copyright © 2018 Justin Trautman. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Reload TableView
    func reloadViews() {
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addPersonButtonTapped(_ sender: Any) {
        
        let addPersonAlertController = UIAlertController(title: "Add New Person", message: "Enter a new name.", preferredStyle: .alert)
        
        var newPersonTextField = UITextField()
        
        addPersonAlertController.addTextField { (textField) in
            textField.placeholder = "Add New Person"
            newPersonTextField = textField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let addText = newPersonTextField.text, !addText.isEmpty else { return }
            
            let newPerson = addText
            PeopleController.shared.createNewPerson(newPerson: newPerson)
            self.reloadViews()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addPersonAlertController.addAction(addAction)
        addPersonAlertController.addAction(cancelAction)
        
        self.present(addPersonAlertController, animated: true)
    }
    
    @IBAction func randomizePeopleButtonTapped(_ sender: Any) {
        
        let numberOfEntries = PeopleController.shared.people.count
        
        if numberOfEntries >= 2 {
            PeopleController.shared.randomizePeople()
            reloadViews()
        } else {
            let insufficientAmountAlert = UIAlertController(title: "Not enough entries!", message: "Add at least two entries", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            insufficientAmountAlert.addAction(okAction)
            
            self.present(insufficientAmountAlert, animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if PeopleController.shared.people.count % 2 == 0 {
            return PeopleController.shared.people.count / 2
        } else {
            return (PeopleController.shared.people.count / 2) + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if PeopleController.shared.people.count % 2 == 0 {
            return 2
        } else {
            if section == (tableView.numberOfSections - 1) {
                return 1
            } else {
                return 2
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section #\(section + 1)"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
        
        let people = PeopleController.shared.people[indexPath.row]
        
        cell.textLabel?.text = people
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let person = PeopleController.shared.people[indexPath.row]
            
            PeopleController.shared.deletePerson(person: person)
            reloadViews()
            
        }
    }
}
