//
//  ViewController.swift
//  Phone Contacts
//
//  Created by Sergei Romanchuk on 15.08.2021.
//

import UIKit
import Contacts

class ContactsViewController: UITableViewController {
    
    private let contactsModel: ContactsLogicModel = ContactsLogicModel()
    private var contacts: [CNContact] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set title to navigation view
        self.title = "Contacts"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom table view cell
        tableView.register(UINib(nibName: Identifier.Nib.contactCell.rawValue, bundle: nil), forCellReuseIdentifier: Identifier.contactCellIdentifier.rawValue)
        
        // Fetch contacts from phone storage
        contactsModel.fetchPhoneContacts { [weak self] result in
            switch result {
            case .success(let data):
                self?.contacts = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let phoneNumber = contacts[indexPath.row].phoneNumbers.first?.value.stringValue else { fatalError("None phone number!") }
        contactsModel.callToContact(to: phoneNumber)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.contactCellIdentifier.rawValue, for: indexPath) as? ContactTableViewCell else {
            fatalError("Unable to dequeue contact cell.")
        }
        
        // Check full name availability
        if contacts[indexPath.row].givenName.isEmpty && contacts[indexPath.row].middleName.isEmpty && contacts[indexPath.row].familyName.isEmpty {
            cell.contactFullName.text = "None"
        } else {
            cell.contactFullName.text = "\(contacts[indexPath.row].givenName) \(contacts[indexPath.row].middleName.isEmpty ? "" : contacts[indexPath.row].middleName + " ")\(contacts[indexPath.row].familyName)"
        }
        
        
        // Check phone number availability
        if contacts[indexPath.row].phoneNumbers.isEmpty {
            cell.contactPhoneNumber.text = "None"
        } else {
            cell.contactPhoneNumber.text = contacts[indexPath.row].phoneNumbers.first?.value.stringValue
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
}
