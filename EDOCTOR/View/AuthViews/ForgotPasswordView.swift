//
//  ForgotPasswordView.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/8/22.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var authVM: AuthVM
//    @StateObject var authVM = AuthVM()
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            HStack {
                Spacer()
                Text("**Reset Password**")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.leading, 60)
                
                Spacer()
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .onTapGesture {
                        mode.wrappedValue.dismiss()
                    }
            }
            .padding()
            .background(navigationColor)
            
            Spacer()
            
            // title texts....
            VStack(alignment: .leading, spacing: 10) {
                Text("**Forgot Password?**")
                    .font(.title2)
                
                Text("Enter your registerd email address to reset your password.")
                    .font(.title3)
            }
            .padding()
            
            //
            ReusableTextField(tile: "Email address",
                              placeholder: "someone@example.com",
                              fieldldFor: $authVM.email)
            
            
            Button {
                authVM.resetPassword()
                
            } label: {
                ReusableButton(title: "Reset")
                    .padding()
                    .padding(.horizontal, 50)
            }

            Spacer()
        }
        .alert(item: $authVM.alertItem, content: { AlertItem in
            Alert(title: AlertItem.title,
                  message: AlertItem.message,
                  dismissButton: .default(Text("Okay!")) {
                if authVM.ruler == Rules.passwordResetted {
                    authVM.ruler = Rules.defaultRule
                    mode.wrappedValue.dismiss()
                }
            }
            )
        })
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
