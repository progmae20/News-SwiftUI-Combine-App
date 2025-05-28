//
//  Extensions.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import SwiftUI
import Foundation

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

extension Binding {
    func map<T>(get: @escaping (Value) -> T, set: @escaping (T) -> Value) -> Binding<T> {
        Binding<T>(
            get: { get(wrappedValue) },
            set: { wrappedValue = set($0) }
        )
    }
}

extension Error {
    var localizedDescription: String {
        if let urlError = self as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection"
            case .timedOut:
                return "Request timed out"
            case .badServerResponse:
                return "Invalid server response"
            default:
                return "Network error occurred"
            }
        }
        return (self as NSError).localizedDescription
    }
}

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}

struct IdentifiableURL: Identifiable {
    let url: URL
    var id: String { url.absoluteString }
}

extension URL {
    var identifiable: IdentifiableURL {
        IdentifiableURL(url: self)
    }
}
