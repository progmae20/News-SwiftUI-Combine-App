//
//  AllNewsOverviewView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 28.05.25.
//

import SwiftUI

struct AllNewsOverviewView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "newspaper.fill")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("All News in One Place")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Stay informed quickly and conveniently")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Go Back") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
