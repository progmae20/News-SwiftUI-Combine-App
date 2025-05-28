//
//  PremiumView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 28.05.25.
//


import SwiftUI

struct PremiumView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Read. Learn. Share.")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                Text("Only fresh and verified news")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "checkmark.seal", text: "Verified sources only")
                    FeatureRow(icon: "bolt", text: "Breaking news alerts")
                    FeatureRow(icon: "newspaper", text: "Exclusive content")
                }
                .padding()
                
                Button("Try Premium") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .presentationDetents([.large])
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
            Spacer()
        }
    }
}
