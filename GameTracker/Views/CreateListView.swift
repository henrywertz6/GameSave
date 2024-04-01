import SwiftUI

struct CreateListView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @State private var listName: String = ""
    @State private var testText: String = ""
    @State private var isPublic: Bool = true
    @State private var selectedGameIDs: Set<String> = []
    @State private var showAddGameCover: Bool = false
    @StateObject var viewModel = ListViewModel() // View model for data handling
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
//            Form {
//                Section {
//                    TextField("List Name", text: $listName)
//                    Picker("Privacy", selection: $isPublic) {
//                        Text("Public").tag(true)
//                        Text("Private").tag(false)
//                    }
//                    // Add a TextEditor for description if needed
//                } header: {
//                    Text("List Details")
//                }
//                Button("Create List") {
//                    // Call view model function to save the list with selected games
//                }
//            }
            
            Button() {
                showAddGameCover = true
            } label: {
                Text("Add Games")
                    .padding()
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            
            
            
            Spacer()
            
        }
        .sheet(isPresented: $showAddGameCover, content: {
            VStack {
                TextField("Search video games...", text: $searchViewModel.searchText)
                    .padding()
                
                List(searchViewModel.searchResults) { game in
                    Text(game.name)
                }
            }
            .onDisappear {
                searchViewModel.cancellable?.cancel()
            }
            .onAppear {
                searchViewModel.setupDebounceSubscription()
            }
        })
        .navigationTitle("New List")
    }
    
    private func toggleGameSelection(_ gameID: String) {
        if selectedGameIDs.contains(gameID) {
            selectedGameIDs.remove(gameID)
        } else {
            selectedGameIDs.insert(gameID)
        }
    }
}


#Preview {
    NavigationStack {
        CreateListView().environmentObject(UserEnvironment())
    }
}
