//
//  SearchViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/27/24.
//

import Foundation
import Typesense
import Combine

@MainActor class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [GameSearchResult] = []
    private let client: Client
    private let debounceDelay: TimeInterval = 0.5
    var cancellable: AnyCancellable? = nil
    init() {
        let node = Node(host: "slt01o36gh9x8i5rp-1.a1.typesense.net", port: "443", nodeProtocol: "https")
        let config = Configuration(nodes: [node], apiKey: "j1IAxRKc7lYCfFBKsaEs5GL2B4HoF4vz")
        self.client = Client(config: config)
        
        setupDebounceSubscription()
    }
    
    func setupDebounceSubscription() {
        cancellable = $searchText
            .debounce(for: .seconds(debounceDelay), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                Task {
                    try await self?.search()
                }
            }
    }
    func search() async throws {
        if searchText.isEmpty {
            searchResults = []
            return
        }
        let searchParameters = SearchParameters(
            q: searchText,
            queryBy: "name",
            sortBy: "_text_match:desc"
        )
        
        let (unmappedResults, _) = try await client.collection(name: "gamesearch").documents().search(searchParameters, for: GameSearchResult.self)
        let mappedResults = unmappedResults?.hits?.compactMap {$0.document}
        self.searchResults = mappedResults ?? []
    }
    
    deinit {
        cancellable?.cancel()
    }
}

struct GameSearchResult: Codable, Identifiable {
    let id: String
    let name: String
}
