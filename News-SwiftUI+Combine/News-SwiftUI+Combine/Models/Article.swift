//
//  Untitled.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//


import Foundation

struct Article: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let type: String
    let sectionId: String
    let sectionName: String
    let webPublicationDate: String
    let webTitle: String
    let webUrl: String
    let apiUrl: String
    let isHosted: Bool
    let pillarId: String
    let pillarName: String
    
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: webPublicationDate) else { return "" }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy"
        return outputFormatter.string(from: date)
    }
    
    var categoryIcon: String {
        switch pillarName {
        case "Arts": return "paintpalette"
        case "News": return "newspaper"
        case "Sport": return "sportscourt"
        case "Opinion": return "quote.bubble"
        case "Lifestyle": return "heart"
        default: return "dot.square"
        }
    }
}

extension Article {
    static var previewData: [Article] = [
        Article(
            id: "1", type: "article", sectionId: "culture", sectionName: "Culture",
            webPublicationDate: "2025-05-22T10:00:00Z", webTitle: "Street Art Festival Transforms City Walls",
            webUrl: "https://example.com/art1", apiUrl: "https://api.example.com/art1",
            isHosted: false, pillarId: "arts", pillarName: "Arts"
        )
    ]
}
