//
//  NavigationBlock.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import Foundation

struct NavigationBlock: Identifiable, Codable, Hashable {
    let id: Int
    let title: String?
    let titleSymbol: String?
    let subtitle: String?
    let buttonTitle: String
    let buttonSymbol: String?
    let navigationType: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case titleSymbol = "title_symbol"
        case subtitle
        case buttonTitle = "button_title"
        case buttonSymbol = "button_symbol"
        case navigationType = "navigation"
    }
}

extension NavigationBlock {
    static var previewData: [NavigationBlock] = [
        NavigationBlock(
            id: 1,
            title: "All News in One Place",
            titleSymbol: nil,
            subtitle: "Stay informed quickly and conveniently",
            buttonTitle: "Go",
            buttonSymbol: "arrow.right",
            navigationType: "all_news"
        ),
        NavigationBlock(
            id: 2,
            title: "Be First to Know What Matters",
            titleSymbol: "star.circle.fill",
            subtitle: nil,
            buttonTitle: "Start Reading",
            buttonSymbol: "arrow.up.right",
            navigationType: "modal"
        ),
        NavigationBlock(
            id: 3,
            title: "Read. Learn. Share.",
            titleSymbol: nil,
            subtitle: "Only fresh and verified news",
            buttonTitle: "Try Premium",
            buttonSymbol: nil,
            navigationType: "full_screen"
        )
    ]
}
