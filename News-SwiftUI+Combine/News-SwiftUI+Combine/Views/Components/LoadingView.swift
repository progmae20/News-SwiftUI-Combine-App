//
//  LoadingView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 28.05.25.
//

import SwiftUI

struct LoadingView: View {
    var message: String = "Loading news..."
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
