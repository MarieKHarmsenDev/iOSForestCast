//
//  DateExtension.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//

import UIKit

extension Date {
    
    var dateAsString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
