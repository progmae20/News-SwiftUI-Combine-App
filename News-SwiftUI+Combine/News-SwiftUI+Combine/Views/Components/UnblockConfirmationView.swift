//
//  UnblockConfirmationView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 25.05.25.
//

import SwiftUI

struct UnblockConfirmationView: View {
    let article: Article
    let confirmAction: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "slash.circle")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("Unblock this news source?")
                .font(.headline)
            
            Text("\"\(article.webTitle)\" will appear in your feed again")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Unblock") {
                    confirmAction()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
