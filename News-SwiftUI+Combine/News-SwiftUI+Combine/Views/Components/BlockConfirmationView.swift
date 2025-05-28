//
//  BlockConfirmationView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 25.05.25.
//

import SwiftUI

struct BlockConfirmationView: View {
    let article: Article
    let confirmAction: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "slash.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Block this news source?")
                .font(.headline)
            
            Text("You won't see articles from \(article.sectionName) anymore")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Block", role: .destructive) {
                    confirmAction()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
