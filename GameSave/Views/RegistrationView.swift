//
//  RegistrationView.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/21/24.
//

import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject var userEnvironment: UserEnvironment
    @Binding var showSignInView: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    var body: some View {
        VStack {
            TextField("Username...", text: $viewModel.display_name)
                .padding()
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Button {
                Task {
                    do {
                        let createdUser = try await viewModel.signUp()
                        userEnvironment.user = createdUser
                        try await UserManager.shared.createNewUser(auth: createdUser!)
                        showSignInView = false
                        return
                    } catch {
                        showAlert = true
                        alertMessage = "Sign up failed. Please try again."
                    }
                    
                }
            } label: {
                Text("Finish Signing Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.vertical, 6)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Finish Signing Up")
        
    }
}

#Preview {
    NavigationStack {
        RegistrationView(viewModel: AuthViewModel(), showSignInView: .constant(false))
    }
}
