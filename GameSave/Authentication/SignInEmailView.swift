//
//  SignInEmailView.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/27/24.
//

import SwiftUI

struct SignInEmailView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject var userEnvironment: UserEnvironment
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
            
            Button {
                Task {
                    
                    do {
                        let signedInUser = try await viewModel.signIn()
                        userEnvironment.user = signedInUser
                        showSignInView = false
                        return
                    } catch {
                        showAlert = true
                        alertMessage = "Invalid credential/email does not exist"
                        print(error)
                    }
                }
            } label: {
                Text("Sign In")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
            }
            
            NavigationLink {
                    ForgotPasswordView(showSignInView: $showSignInView)
            } label: {
                Text("Forgot password")
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.top, 25)
            
            Spacer()
                
            
                
        }
        .padding()
        .navigationTitle("Sign In With Email")
        .alert(showAlert ? alertMessage : "", isPresented: $showAlert) { // Alert for email sent
            Button("OK") { } // Dismiss button
        }
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
            .environmentObject(UserEnvironment())
    }
}
