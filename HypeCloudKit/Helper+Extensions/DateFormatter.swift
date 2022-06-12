//
//  DateFormatter.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/11/22.
//

import Foundation


extension Date {
    func dateFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
