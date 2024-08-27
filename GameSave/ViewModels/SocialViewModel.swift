//
//  SocialViewModel.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/8/24.
//

import Foundation
import Typesense
import Combine
@MainActor class SocialViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [UserSearch] = []
    @Published var socialActivity: [ActivityLog] = []
    @Published var displayNames: [String:String] = [:]
    private let client: Client
    var cancellable: AnyCancellable? = nil
    private let debounceDelay: TimeInterval = 0.5
    
    init() {
        let node = Node(host: "slt01o36gh9x8i5rp-1.a1.typesense.net", port: "443", nodeProtocol: "https")
        let config = Configuration(nodes: [node], apiKey: "j1IAxRKc7lYCfFBKsaEs5GL2B4HoF4vz")
        self.client = Client(config: config)
        setupDebounceSubscription()
    }
    
    func setupDebounceSubscription() {
        cancellable = $searchText
            .debounce(for: .seconds(debounceDelay), scheduler: DispatchQueue.main)
            .sink {[weak self] query in
                Task {
                    try await self?.searchUser()
                }
            }
    }
    func searchUser() async throws {
        if searchText.isEmpty {
            searchResults = []
            return
        }
        let searchParameters = SearchParameters(
            q: searchText,
            queryBy: "display_name",
            sortBy: "_text_match:desc"
        )
        
        let (unmappedResults, _) = try await client.collection(name: "usersearch").documents().search(searchParameters, for: UserSearch.self)
        let mappedResults = unmappedResults?.hits?.compactMap {$0.document}
        self.searchResults = mappedResults ?? []
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func getSocialActivity(userId: String, following: Set<String>) async throws {
        self.socialActivity = try await UserManager.shared.getSocialActivity(userId: userId, following: following)
    }
    
    func getDisplayNames() async throws {
        self.displayNames = try await UserManager.shared.getDisplayNames(activityLogs: socialActivity)
    }
}
