//
//  ListView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/1/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject var viewModel = ListViewModel()
    @State private var showSheet: Bool = false
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding()
                .sheet(isPresented: $showSheet, content: {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 40, height: 6)
                        .foregroundStyle(Color.secondary)
                        .padding(.top, 8)
                    NavigationStack {
                        CreateListView(isPresented: $showSheet)
                    }
                })
            }
            .navigationTitle("Lists")
        }
    }
}

#Preview {
    ListView().environmentObject(UserEnvironment())
}
