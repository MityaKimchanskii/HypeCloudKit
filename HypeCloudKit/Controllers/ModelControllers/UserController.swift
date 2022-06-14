//
//  UserController.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/13/22.
//

import CloudKit

class UserController {
    
    // MARK: - Properties
    static let shared = UserController()
    var currentUser: User?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    // Create User
    func createUser(with username: String, bio: String, completion: @escaping (Bool) -> Void) {
        
        fetchAppleUserReference { reference in
            guard let reference = reference else { completion(false); return }
            let newUser = User(username: username, bio: bio, appleUserReference: reference)
            let record = CKRecord(user: newUser)
            
            self.publicDB.save(record) { (record, error) in
                if let error = error {
                    print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                    completion(false)
                    return
                }
                
                guard let record = record,
                        let savedUser = User(ckRecord: record)
                else { completion(false); return }
                self.currentUser = savedUser
                completion(true)
            }
        }
    }
    
    // Read User
    func fetchUser(completion: @escaping (Bool) -> Void) {
        
        fetchAppleUserReference { reference in
            
            guard let reference = reference else { completion(false); return }
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserReferenceKey, reference])
            let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                    completion(false)
                    return
                }
                
                guard let record = records?.first,
                      let foundUser = User(ckRecord: record)
                else { completion(false); return }
                
                self.currentUser = foundUser
                print("Fetched user: \(record.recordID.recordName) successfully!")
                completion(true)
            }
        }
    }
    
    // Update User
    func updateUser(_ user: User) {
        
    }
    
    // Delete User
    func deleteUser(_ user: User) {
        
    }
    
    // MARK: - Helper Methods
    private func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            
            guard let recordID = recordID else { completion(nil); return }
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            completion(reference)
            
        }
    }
}
