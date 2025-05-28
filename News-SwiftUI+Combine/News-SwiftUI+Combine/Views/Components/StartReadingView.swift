//
//  StartReadingView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 28.05.25.
//

import SwiftUI

struct StartReadingView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.yellow)
            
            Text("Be First to Know What Matters")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Get instant notifications about breaking news and important updates")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Start Reading") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
        .presentationDetents([.medium])
    }
}
