//
//  IntervalExtension.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//

import UIKit

extension TimeInterval {
    var unixAsDayOfWeek: String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
