//
//  ErrorView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 05/04/2025.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Image(systemName: "xmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.primary)
                .padding()
            
            Regular(text: "Unexpected Error", color: .black)
        }
    }
}

#Preview {
    ErrorView()
}
