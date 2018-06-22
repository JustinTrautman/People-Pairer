//
//  PeopleController.swift
//  People Pairer
//
//  Created by Justin Trautman on 6/22/18.
//  Copyright © 2018 Justin Trautman. All rights reserved.
//

import Foundation

typealias Person = String

class PeopleController {
    
    // Shared Instance
    static let shared = PeopleController()
    
    // Source of Truth
    var people: [Person] = []
    
    init() {
        loadPeople()
    }
    
    // CRUD Functions
    
    // Create
    func createNewPerson(newPerson: Person) {
        
        people.append(newPerson)
        savePeople()
    }

    // Read
    private func fileURL() -> URL {
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "person.json"
        let documentsDirectoryURL = url[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    func loadPeople() {
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let people = try decoder.decode([Person].self, from: data)
            self.people = people
        } catch let error {
            print("There was an error loading from persistent storage: \(error.localizedDescription)")
        }
    }
    
    // Randomize
    func randomizePeople() {
        
        var randomize: [Person] = []
        for person in people {
            let index = Int(arc4random_uniform(UInt32(randomize.count)))
            randomize.insert(person, at: index)
        }
        people = randomize
    }

    // Update
    func savePeople() {
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(people)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving to persistent storage: \(error.localizedDescription)")
        }
    }
    
    // Delete
    func deletePerson(person: Person) {
        
        if let index = people.index(of: person) {
        people.remove(at: index)
        savePeople()
        }
    }
}
