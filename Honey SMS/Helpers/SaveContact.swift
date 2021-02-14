//
//  SaveContact.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 05/02/21.
//

import Foundation

import UIKit
import Contacts

class Contact {
    // Create a mutable object to add to the contact
    
    func SaveContact (lead : LeadsModel) {
        
        let contact = CNMutableContact()
        contact.givenName = lead.data[0].nome
        contact.phoneNumbers = [CNLabeledValue(
                                    label: CNLabelPhoneNumberiPhone,
                                    value: CNPhoneNumber(stringValue: lead.data[0].telefone))]
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)

        do {
            try store.execute(saveRequest)

            
            
            
        } catch {
            print("Saving contact failed, error: \(error)")
       
        }
        
        
    }
    
    func openWhatsapp(phoneNumber:String){
        let urlWhats = "whatsapp://send?phone=\(phoneNumber)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }


}
    
    

