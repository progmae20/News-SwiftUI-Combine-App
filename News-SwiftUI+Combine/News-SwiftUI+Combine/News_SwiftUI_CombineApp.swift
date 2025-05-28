//
//  News_SwiftUI_CombineApp.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//


import SwiftUI

@main
struct News_SwiftUI_CombineApp: App {
    var body: some Scene {
        WindowGroup {
            NewsTabView()
                .environmentObject(NewsViewModel())
        }
    }
}
