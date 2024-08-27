//
//  AuthenticationView.swift
//  GameTracker
//
//  Created by Henry Wertz on 2/27/24.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                
                
                
            }
            
            NavigationLink {
                SignUpEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign Up With Email")
                    .font(.headline)
                        .foregroundColor(.blue)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal)
                    
            }
        }
        .navigationTitle("Welcome")
        
        Spacer()
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
