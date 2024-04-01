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
    var body: some View {
        NavigationStack {
            Text("this is the list view")
        }
    }
}

#Preview {
    ListView().environmentObject(UserEnvironment())
}
