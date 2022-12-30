//
//  SignupView.swift
//  EDOCTOR
//
//  Created by Maani on 10/17/21.
//

import SwiftUI

struct SignupView: View {
    
    @EnvironmentObject var authVM: AuthVM
//    @StateObject var authVM = AuthVM()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            
            //navigation links
            NavigationLink(
                destination: HomeView().navigationBarHidden(true),
                isActive: $authVM.homeToggle){}
                .hidden()
            
            // body content....
            ScrollView {
                // title texts....
                HStack {
                    VStack(alignment: .leading, spacing:10) {
                        Text("**Welcome**")
                            .font(.title)
                        Text("**Create an account to continue.**")
                            .font(.title3)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 40)
                .padding(.horizontal)
                
                // text fields....
                VStack(alignment: .leading, spacing: 0) {
                    
                    // first name & last name....
                    HStack(spacing: -20) {
                        ReusableTextField(tile: "First name",
                                          placeholder: "Marina",
                                          fieldldFor: $authVM.fName)
                        
                        ReusableTextField(tile: "Last name",
                                          placeholder: "Soozi",
                                          fieldldFor: $authVM.lName)
                    }
                    
                    // email....
                    ReusableTextField(tile: "Email address",
                                      placeholder: "someone@example.com",
                                      fieldldFor: $authVM.email)
                    
                    // gender....
                    ZStack {
                        ReusableTextField(tile: "Gender", placeholder: "Not selected", fieldldFor: $authVM.gender)
                            .disabled(true)
                            .onAppear() { authVM.gender = "Male"}
                            .onChange(of: authVM.genderStatus) { _ in
                                if authVM.genderStatus { authVM.gender = "Male"}
                                else { authVM.gender = "Female" }
                        }
                        HStack(alignment: .center) {
                            Spacer()
                            Toggle("", isOn: $authVM.genderStatus)
                                .tint(navigationColor)
                                 
                        }.padding(.horizontal).padding(.top, 30).padding(.horizontal)
                    }
                    
                    // Date of birth....
                    ZStack {
                        ReusableTextField(tile: "Date of birth",
                                          placeholder: "Not selected",
                                          fieldldFor: $authVM.dateOfBirth)
                            .disabled(true)
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(navigationColor)
                                .onTapGesture {
                                    authVM.showDatePicker.toggle()
                                }
                        }
                        .padding(.horizontal).padding(.top, 30).padding(.horizontal)
                    }
                    
                    // password....
                    ReusableTextField(tile: "Password",
                                      placeholder: "********",
                                      fieldldFor: $authVM.password,
                                      fieldType: "password")
                }
                
                Spacer(minLength: 45)
                
                // Sign up button....
                Button(action: {
                    authVM.Signup()
                }, label: {
                    ReusableButton(title: "SIGN UP")
                        .padding(.horizontal, 70)
                })
                
                // go back to login
                HStack {
                    Text("Already have an account?")
                        .font(.title3)
                    
                    Text("**Login**")
                        .font(.title3)
                        .underline()
                        .onTapGesture {
                            mode.wrappedValue.dismiss()
                        }
                }
                .padding(.bottom, 5)
        }
            .blur(radius: authVM.loading ? 6:0)
            .background(appColor)
            .opacity(authVM.loading ? 0.7 : 1)
                if authVM.loading {
                    LoadingView()
                }
        }
        .navigationBarHidden(true)
        .alert(item: $authVM.alertItem, content: { AlertItem in
            Alert(title: AlertItem.title,
                  message: AlertItem.message,
                  dismissButton: .default(Text("Okay!")) {
                if authVM.ruler == Rules.registerSuccess {
                    authVM.ruler = Rules.defaultRule // resetting....
                    mode.wrappedValue.dismiss()
                }
            }
            )
        })
        .sheet(isPresented: $authVM.showDatePicker) {
            DatePickerView(selectedDate: $authVM.dateOfBirth,
                           message: "Choose your date of brith")
        }
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
