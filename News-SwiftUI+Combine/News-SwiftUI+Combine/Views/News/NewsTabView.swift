//
//  NewsTabView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import SwiftUI

struct NewsTabView: View {
    @StateObject private var viewModel = NewsViewModel()
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(NewsViewModel.Tab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.selectedTab = tab
                            }
                        }) {
                            Text(tab.rawValue)
                                .font(.subheadline.bold())
                                .foregroundColor(viewModel.selectedTab == tab ? .white : .primary)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    Group {
                                        if viewModel.selectedTab == tab {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.blue)
                                                .matchedGeometryEffect(id: "tab", in: animation)
                                        }
                                    }
                                )
                        }
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                TabView(selection: $viewModel.selectedTab) {
                    AllNewsView()
                        .tag(NewsViewModel.Tab.all)
                    
                    FavoritesView()
                        .tag(NewsViewModel.Tab.favorites)
                    
                    BlockedView()
                        .tag(NewsViewModel.Tab.blocked)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(viewModel)
    }
}

struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewsTabView()
                .environmentObject(NewsViewModel.preview)
            
            NewsTabView()
                .environmentObject(NewsViewModel.preview)
                .preferredColorScheme(.dark)
        }
    }
}
