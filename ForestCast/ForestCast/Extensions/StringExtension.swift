//
//  StringExtension.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: self) else {
            return ""
        }
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: self) else {
            return ""
        }
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
