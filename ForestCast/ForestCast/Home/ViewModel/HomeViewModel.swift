//
//  HomeViewModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//
import SwiftUI

class HomeViewModel {
    
    var backgroundColor: Color {
        return Color.sunny
    }

    enum DaysOfWeek: String, CaseIterable {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
    }
    
}
