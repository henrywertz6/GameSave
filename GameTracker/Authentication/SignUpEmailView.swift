//
//  SignInEmailView.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/27/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpEmailView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            NavigationLink {
                RegistrationView(viewModel: viewModel, showSignInView: $showSignInView)
            } label: {
                Text("Sign Up")
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
        .navigationTitle("Sign Up With Email")
        .alert(showAlert ? alertMessage : "", isPresented: $showAlert) { // Alert for email sent
            Button("OK") { } // Dismiss button
        }
    }
}

#Preview {
    NavigationStack {
        SignUpEmailView(showSignInView: .constant(false))
            .environmentObject(UserEnvironment())
    }
}
