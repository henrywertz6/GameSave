//
//  ForgotPasswordView.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/15/24.
//

import SwiftUI

struct ForgotPasswordView: View {
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
            
            
            
            Button {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        showAlert = true
                        alertMessage = "A password reset email has been sent to your inbox."
                    } catch {
                        print(error)
                        showAlert = true
                        alertMessage = "Email not found. Please sign up for a new account."
                        // Handle errors (e.g., network issues)
                    }
                }
            } label: {
                Text("Submit")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
            }
            
            
            Spacer()
        }
        .padding()
        .navigationTitle("Forgot password")
        .alert(showAlert ? alertMessage : "", isPresented: $showAlert) { // Alert for email sent
            Button("OK") { } // Dismiss button
        }
        
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView(showSignInView: .constant(false))
    }
}
