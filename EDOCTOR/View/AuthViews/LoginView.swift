//
//  ContentView.swift
//  EDOCTOR
//
//  Created by Maani on 10/17/21.
//

import SwiftUI
import Foundation

struct LoginView: View {
    
    @StateObject var authVM = AuthVM()
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(navigationColor)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(.white)]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        UINavigationBar.appearance().tintColor = UIColor(.white)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                        Image("LOGO")
                        .padding(.top, 30)
                           
                        Spacer(minLength: 120)
                        
                        // body
                        VStack(alignment: .leading) {
                            
                            // title texts....
                            VStack(alignment: .leading, spacing: 5) {
                                Text("**Hello,**")
                                    .font(.title)
                                
                                Text("Sign into your Account")
                                    .multilineTextAlignment(.center)
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }.padding(.leading)
                            
                            Spacer(minLength: 50)
                            
                            // Text Fields...
                            VStack(alignment: .leading, spacing: 0) {
                                NavigationLink(
                                    destination: SignupView().navigationBarHidden(true)
                                        .environmentObject(authVM),
                                    isActive: $authVM.signupToggle){}
                                    .hidden()
                                
                                NavigationLink(
                                    destination: HomeView().navigationBarHidden(true),
                                    isActive: $authVM.homeToggle){}
                                    .hidden()
                                
                                ReusableTextField(tile: "Email address",
                                                  placeholder: "someone@example.com",
                                                  fieldldFor: $authVM.email)
                                
                                ReusableTextField(tile: "Password",
                                                  placeholder: "********",
                                                  fieldldFor: $authVM.password,
                                                  fieldType: "password")
                                
                                HStack {
                                    Spacer()
                                    Text("Forgot Password!")
                                        .padding([.trailing, .top])
                                        .onTapGesture {
                                            authVM.forgotPasswordToggle.toggle()
                                        }
                                }
                            }
                            
                            Spacer(minLength: 80)
                            
                            // Login button
                            Button(action: {
                                authVM.Login()
                            }, label: {
                                ReusableButton(title: "LOGIN")
                                    .padding(.horizontal, 70)
                            })
                            
                            Spacer(minLength: 50)
                            
                            // goto signup text and button
                            HStack {
                                Spacer()
                                Text("Don't have an account?")
                                    .font(.title3)
                                Text("**Register**")
                                    .font(.title3)
                                    .underline()
                                    .onTapGesture {
                                        authVM.signupToggle.toggle()
                                    }
                                Spacer()
                            }
                            .padding(.bottom)
                        }
                }
                .background(appColor)
                .blur(radius: authVM.loading ? 6:0)
                .opacity(authVM.loading ? 0.7 : 1)
                if authVM.loading {
                    LoadingView()
                }
                
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $authVM.forgotPasswordToggle) {
            ForgotPasswordView()
                .environmentObject(authVM)
        }
        .alert(item: $authVM.alertItem, content: { AlertItem in
            Alert(title: AlertItem.title,
                  message: AlertItem.message,
                  dismissButton: .default(Text("Okay!"))
            )
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
