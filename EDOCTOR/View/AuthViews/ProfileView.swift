//
//  ProfileView.swift
//  EDOCTOR
//
//  Created by Maani on 10/18/21.
//
//calendar
import SwiftUI
import AVFoundation
import SwiftfulLoadingIndicators

struct ProfileView: View {
    
    @State var name: String = "M Salman"
    @State var DateheetToggle = false
    
    @State var selectedGender: String = "Male"
    @State var isShowingGenderAlert = false
    
    @StateObject var authVM = AuthVM()
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false)   {
        VStack(alignment: .leading) {
            // enabling updating profile button
            VStack(alignment: .leading) {
                HStack {
                    Text("Update profile")
                    Spacer()
                    
                    Image(systemName: authVM.updateProfileIcon)
                        .font(.title)
                        .foregroundColor(navigationColor)
                        .onTapGesture {
                            withAnimation {
                                authVM.isUpdatingEnabled.toggle()
                                if authVM.updateProfileIcon == "lock.fill" {
                                    AudioServicesPlaySystemSound(1004)
                                    authVM.updateProfileIcon = "lock.open.fill"
                                    
                                } else {
                                    AudioServicesPlaySystemSound(1003)
                                    authVM.updateProfileIcon = "lock.fill"
                                    
                                }
                            }
                        }
                    
                }
                
                Divider()
                
                HStack(spacing: 10) {
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 5)
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(lineWidth: 1))
                    }
                    VStack(alignment: .leading, spacing: 1) {
                        Text(authVM.fullName)
//                            .foregroundColor(secondaryColor)
                            .font(.title2)
                        
                        Text(authVM.email)
//                            .foregroundColor(secondaryColor)
                            .font(.title3)
                    }
                    Spacer()
                }
                .padding([.top, .bottom], 10)
                .disabled(authVM.isUpdatingEnabled ? false:true)
            }
            .padding()
            .background(appColor2)
            .cornerRadius(10)
            .padding()
            
            // Name
            if !authVM.isUpdatingEnabled {
                    Text("Full name")
                        .padding(.leading)
                VStack(alignment: .leading) {
                        TextField("Full Name", text: $authVM.fullName)
                            .disabled(authVM.isUpdatingEnabled ? false:true)
                    }
                    .padding()
                    .background(appColor2)
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text("First name")
                            .padding(.leading)
                        VStack {
                            TextField("Full Name", text: $authVM.fName)
                                .disabled(authVM.isUpdatingEnabled ? false:true)
                        }
                        .padding()
                        .background(appColor2)
                        .cornerRadius(10)
                        .padding([.leading, .trailing])
                    }
                    VStack(alignment: .leading) {
                        Text("Last name")
                            .padding(.leading)
                        VStack {
                            TextField("Full Name", text: $authVM.lName)
                                .disabled(authVM.isUpdatingEnabled ? false:true)
                        }
                        .padding()
                        .background(appColor2)
                        .cornerRadius(10)
                        .padding([.leading, .trailing])
                    }
                }
            }
            
            
            
            // Gender
            Text("Gender")
                .padding([.leading, .top])
            VStack{
                HStack(spacing: 10) {
                    Text(authVM.gender)
                    
                    Spacer()
                    HStack {
                        Text("Change")
                        Image(systemName: "chevron.forward")
                    }
                    .onTapGesture {
                        withAnimation {
                            isShowingGenderAlert.toggle()
                        }
                    }
                }
                .alert("Select your gender!", isPresented: $isShowingGenderAlert) {
                    Button("Male", action: {
                        authVM.gender = "Male"
                    })
                    Button("Female", action: {
                        authVM.gender = "Female"
                    })
                    Button("Cancel", action: {})
                }
            }
            .disabled(authVM.isUpdatingEnabled ? false:true)
            .padding()
            .background(appColor2)
            .cornerRadius(10)
            .padding([.leading, .trailing])
            
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
                            DateheetToggle.toggle()
                        }
                }
                .padding(.horizontal).padding(.top, 30).padding(.horizontal)
            }
            .disabled(authVM.isUpdatingEnabled ? false:true)
            
            Spacer()
        }
        .padding(.top, 32)
            }
        .padding(.top, 1) // importent for toolbarColor
        .background(toolBarColor)
        .opacity(authVM.isUpdatingEnabled ? 1:0.85)
        
        .alert(isPresented: $authVM.isProfileUpdatingToDatabase) {
            Alert(title: Text("Confirm!"),
                  message: Text("Are you sure you want to update your profile?"),
                  primaryButton: .default(Text("Update")) {
                authVM.updateUserProfile(gender: selectedGender)
            },
                  secondaryButton: .destructive(Text("Cancel")))
        }
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        authVM.isProfileUpdatingToDatabase.toggle()
                    }
                } label: {
                    if authVM.isUpdatingEnabled {
                        Text("Done")
                    }
                }
                
            }
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        .blur(radius: authVM.loading ? 6:0)
        .onAppear() {
            authVM.loading = true
        }
            
            if authVM.loading {
                LoadingView()
            }
            
            
    }
        .sheet(isPresented: $DateheetToggle) {
            DatePickerView(selectedDate: $authVM.dateOfBirth,
                           message: "Choose your date of birth")
        }
        .onAppear {
            if !authVM.userProfileFound {
                authVM.getUserProfile()
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
