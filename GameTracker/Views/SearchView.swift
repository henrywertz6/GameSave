//
//  SearchView.swift
//  Letterboxd4Games
//
//  Created by Henry Wertz on 2/18/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        VStack {
            TextField("Search video games...", text: $viewModel.searchText)
                .padding()
            
            List(viewModel.searchResults) { game in
                Text(game.name)
            }
        }
        .onDisappear {
            viewModel.cancellable?.cancel()
        }
        .onAppear {
            viewModel.setupDebounceSubscription()
        }
        
        
    }
}

#Preview {
    SearchView()
}
