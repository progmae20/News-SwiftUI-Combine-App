//
//  NavigationBlockView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import SwiftUI

struct NavigationBlockView: View {
    let block: NavigationBlock
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            if let symbol = block.titleSymbol {
                Image(systemName: symbol)
                    .font(.system(size: 28))
                    .foregroundColor(.accentColor)
            }
            
            VStack(spacing: 4) {
                if let title = block.title {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                
                if let subtitle = block.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: action) {
                HStack(spacing: 6) {
                    Text(block.buttonTitle)
                    if let symbol = block.buttonSymbol {
                        Image(systemName: symbol)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(block.navigationType == "all_news" ? .blue : .accentColor)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}
