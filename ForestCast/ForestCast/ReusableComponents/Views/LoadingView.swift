//
//  LoadingView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .padding()
            
            Regular(text: "loading.Loading".localized, color: .black)
        }
    }
}

#Preview {
    LoadingView()
}
