//
//  ConfirmListAddView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/3/24.
//

import SwiftUI

struct ConfirmListAddView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    @StateObject var viewModel = DetailViewModel()
    
    var body: some View {
        Button {
            Task {
                guard let user = userEnvironment.user else {return}
                
                
            }
        } label: {
            Text("Add to List")
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .frame(height:55)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .transition(.opacity)
            
        }
    }
}

#Preview {
    ConfirmListAddView()
}
