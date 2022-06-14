//
//  HypeController.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/11/22.
//

import CloudKit


class HypeController {
    
    // MARK: - Properties
    static let shared = HypeController()
    var hypes: [Hype] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    // Create
    func createHype(with text: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { completion(false); return }
        let reference = CKRecord.Reference(recordID: currentUser.recordID, action: .none)
        let newHype = Hype(body: text, userReference: reference)
        let record = CKRecord(hype: newHype)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                  let savedHype = Hype(ckRecord: record)
            else {  completion(false); return }
            
            self.hypes.insert(savedHype, at: 0)
            completion(true)
        }
    }
    
    // Read
    func fetchHypes(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let records = records else {  completion(false); return }
            let fetchedHypes = records.compactMap { Hype(ckRecord: $0) }
            self.hypes = fetchedHypes
            completion(true)
        }
    }
    
    // Update
    func updateHype(with hypeToUpdate: Hype, completion: @escaping (Bool) -> Void) {
        guard hypeToUpdate.userReference?.recordID == UserController.shared.currentUser?.recordID else { completion(false); return }
        let recordToUpdate = CKRecord(hype: hypeToUpdate)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        
        operation.modifyRecordsResultBlock = {  result in
            switch result {
            case .success():
                return completion(true)
            case .failure(_):
                return completion(false)
            }
        }
        
        publicDB.add(operation)
    }
    
    // Delete
    func deleteHype(with hypeToDelete: Hype, completion: @escaping (Bool) -> Void) {
        guard hypeToDelete.userReference?.recordID == UserController.shared.currentUser?.recordID else { completion(false); return }
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [hypeToDelete.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success():
                return completion(true)
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
        }
        
        publicDB.add(operation)
    }
    
    // Remote Notifications
    func subscribeForRemoteNotification(completion: @escaping (Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: HypeStrings.recordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Hello IOS Developer"
        notificationInfo.alertBody = "Dima Kim"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
}
