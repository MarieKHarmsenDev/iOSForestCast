//
//  TextStyles.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//
import SwiftUI

struct Title1: View {
    var text: String
    var color: Color? = .white

    var body: some View {
        Text(text)
            .font(.system(size: 48))
            .foregroundColor(color)
            .kerning(4)
            .bold()
    }
}

struct Title2: View {
    var text: String
    var color: Color? = .white

    var body: some View {
        Text(text)
            .textCase(.uppercase)
            .font(.system(size: 32))
            .foregroundColor(color)
            .kerning(4)
            .bold()
    }
}

struct RegularBold: View {
    var text: String
    var color: Color? = .white

    var body: some View {
        Text(text)
            .font(.system(size: 18))
            .bold()
            .foregroundColor(color)
    }
}

struct Regular: View {
    var text: String
    var color: Color? = .white

    var body: some View {
        Text(text)
            .font(.system(size: 18))
            .foregroundColor(color)
    }
}
