//
//  SocialView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/6/24.
//

import SwiftUI

struct SocialView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject var viewModel = SocialViewModel()
    @State private var showSheet: Bool = false
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                
                List(viewModel.socialActivity) { activityLog in
                    if activityLog.activityType == "List" {
                        NavigationLink(destination: FetchListView(listId: activityLog.listId!)) {
                            Text("\(viewModel.displayNames[activityLog.userId] ?? "") has created a list: \(activityLog.listName ?? "")")
                        }
                    } else if activityLog.activityType == "Game" {
                        NavigationLink(destination: DetailFetchView(gameId: activityLog.gameId ?? "")) {
                            Text("\(viewModel.displayNames[activityLog.userId] ?? "") added \(activityLog.gameName ?? "") to their library")
                        }
                    } else if activityLog.activityType == "Review" {
                        NavigationLink(destination: DetailFetchView(gameId: activityLog.gameId ?? "")) {
                            Text("\(viewModel.displayNames[activityLog.userId] ?? "") reviewed \(activityLog.gameName ?? "")")
                        }
                    }
                    
                    
                }
                .transition(.opacity)
            }
            
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title.weight(.semibold))
                    .padding()
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 4, x: 0, y: 4)
            }
        }
        .onAppear {
            Task {
                guard let user = userEnvironment.user else {return}
                try await viewModel.getSocialActivity(userId: user.uid, following: userEnvironment.following)
                try await viewModel.getDisplayNames()
                
            }
        }
        .padding()
        .navigationTitle("Social")
        .sheet(isPresented: $showSheet, content: {
            NavigationStack {
                SocialSearchView()
            }
        })
    }
}

#Preview {
    NavigationStack {
        SocialView().environmentObject(UserEnvironment())
    }
    
}
