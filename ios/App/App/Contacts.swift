import Foundation
import Capacitor
import Contacts

@objc(Contacts)
public class Contacts : CAPPlugin {
    @objc func getAll(_ call: CAPPluginCall) {
        let contacts = fetchContacts() // TODO: Replace mocked data with real implementation.
       
        call.success([
            "contacts": contacts
        ])
    }
    
    private func getAllMocked() -> [Any] {
        return [
            [
                "firstName": "Elton",
                "lastName": "Json",
                "phoneNumbers": ["2135551111"],
                "emailAddresses": ["elton@eltonjohn.com"],
            ],
            [
                "firstName": "Freddie",
                "lastName": "Mercury",
                "phoneNumbers": [],
                "emailAddresses": [],
            ],
        ]
    }
    
    private func fetchContacts() -> Array<Any> {
        let store = CNContactStore()
        var contacts = [] as Array
        store.requestAccess(for: .contacts) { (granted, error) in
            if granted {
                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                do {
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                    contacts.append(["firstName": contact.givenName , "lastName": contact.familyName , "phoneNumbers": [contact.phoneNumbers.first?.value.stringValue ?? ""], "emailAddresses": [contact.emailAddresses.first?.value ?? ""]])
                    })
                } catch {
                    print("Failed to fetch contact, error: \(error)")
                    // Handle the error

                }
            }
        }
        print(contacts)
        return contacts
    }
}
