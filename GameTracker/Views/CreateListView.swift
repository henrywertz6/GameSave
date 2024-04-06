import SwiftUI

struct CreateListView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @State private var listName: String = ""
    @State private var testText: String = ""
    @State private var isPublic: Bool = true
    @State private var selectedGameIDs: [String] = []
    @State private var selectedGames: [ListObject] = []
    @StateObject var viewModel = ListViewModel() // View model for data handling
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var showToast = false
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            TextField("List title...", text: $listName)
                .padding()
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            NavigationLink(destination: AddGamesView(selectedGameIDs: $selectedGameIDs, selectedGames: $selectedGames)) {
                Text("Add Games")
                    .padding()
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            ScrollView {
                LazyVGrid(columns: columns) {
                    
                    ForEach(Array(selectedGames)) { game in
                        
                        HStack {
                            AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/\(game.image_id ?? "bingus").jpg")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 150)
                                    .overlay(
                                        Text(game.name)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .padding(4)
                                    )
                            }
                            .frame(width: 100, height: 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            
                            
                            
                        }
                    }
                }
            }
            
            Button() {
                Task {
                    guard let user = userEnvironment.user else {return}
                    try await viewModel.createList(userId: user.uid, initialGames: Array(selectedGameIDs), title: listName, isPublic: true)
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isPresented = false
                    }
                }
            } label: {
                Text("Create List")
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
        .toast(message: "List created", isShowing: $showToast)
        .padding()
        .navigationTitle("New List")
        
    }
}


#Preview {
    NavigationStack {
        CreateListView(isPresented: .constant(false)).environmentObject(UserEnvironment())
    }
}
