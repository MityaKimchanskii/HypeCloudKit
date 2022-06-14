//
//  User.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/13/22.
//

import Foundation
import CloudKit

struct UserStrings {
    static let recordTypeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let bioKey = "bio"
    static let appleUserReferenceKey = "appleUserReference"
}

class User {
    var username: String
    var bio: String
    var recordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    init(username: String, bio: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserReference = appleUserReference
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.recordID)
        self.setValue(user.username, forKey: UserStrings.usernameKey)
        self.setValue(user.bio, forKey: UserStrings.bioKey)
        self.setValue(user.appleUserReference, forKey: UserStrings.appleUserReferenceKey)
    }
}

extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
              let appleUserReference = ckRecord[UserStrings.appleUserReferenceKey] as? CKRecord.Reference,
              let bio = ckRecord[UserStrings.bioKey] as? String
        else { return nil }
        
        self.init(username: username, bio: bio, recordID: ckRecord.recordID, appleUserReference: appleUserReference)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
