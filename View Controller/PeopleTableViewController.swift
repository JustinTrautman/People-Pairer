//
//  PeopleTableViewController.swift
//  People Pairer
//
//  Created by Justin Trautman on 6/22/18.
//  Copyright © 2018 Justin Trautman. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    // Randomize Alert
    func ShowrandomizeAlert() {
        let randomizeAlert = UIAlertController(title: "Error Randomizing People", message: "Make sure there's at least two entries and you've entered an even number of people.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        randomizeAlert.addAction(okAction)
        
        present(randomizeAlert, animated: true)
    }
    
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
        
        if numberOfEntries % 2 != 0 || numberOfEntries <= 1 {
            ShowrandomizeAlert()
            
        } else {
            PeopleController.shared.randomizePeople()
            reloadViews()
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
    
    // MARK: - Header Titles
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pair #\(section + 1)"
    }
    
    // Weird duplicate entry error... This func takes the IP section and multiplies it by two and ands one more additional row.
    func alteredIndexPath(indexPath: IndexPath) -> Int {
        return (indexPath.section * 2) + (indexPath.row)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
        
        let people = PeopleController.shared.people[alteredIndexPath(indexPath: indexPath)]
        cell.textLabel?.text = people
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let person = PeopleController.shared.people[alteredIndexPath(indexPath: indexPath)]
            PeopleController.shared.deletePerson(person: person)
            reloadViews()
        }
    }
}
