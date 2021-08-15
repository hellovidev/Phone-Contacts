//
//  ContactsModel.swift
//  Phone Contacts
//
//  Created by Sergei Romanchuk on 15.08.2021.
//

import UIKit
import Contacts

class ContactsLogicModel {
    
    func fetchPhoneContacts(completion: @escaping (Result<[CNContact], Error>) -> Void) {
        // Contacts storage
        var contacts: [CNContact] = []
        
        // Contacts API
        let contactStore: CNContactStore = .init()
        let keys: [Any] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
        let request: CNContactFetchRequest = .init(keysToFetch: keys as! [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) { contact, stop in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                
                for phoneNumber in contact.phoneNumbers {
                    if let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        print("\(contact.givenName) \(contact.familyName) (tel:\(localizedLabel)) - \(phoneNumber.value.stringValue)")
                    }
                }
            }
            
            return completion(.success(contacts))
        } catch {
            return completion(.failure(error))
        }
    }
    
    func callToContact(to phone: String) {
        var invalidSymbols: CharacterSet = .whitespaces
        invalidSymbols.insert(charactersIn: "-)(")
        
        let clearPhoneNumber = String(phone.unicodeScalars.filter(invalidSymbols.inverted.contains(_:)))
        
        if let phoneCallURL = URL(string: "tel://\(clearPhoneNumber)"), UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
    
}
