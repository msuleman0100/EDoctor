//
//  SideBar.swift
//  EDOCTOR
//
//  Created by Maani on 10/30/21.
//


import SwiftUI
import FirebaseAuth
import RealmSwift

struct HomeView: View {
    
    @State var paddingTop: CGFloat = 10
    @State var goToProfileView = false
    @State var diseaseViewToggle = false
    
    @State var isShowingSheet: Bool = false
    @State var logoutAlert = false /// for logout alert
    @State var profileToggle = false
    @State var assessmentToggle = false
    @State var webViewToggle = false
    @State var logoutToggle = false /// for logout
    @State var selectedOption = ""
    @State var symptomsTrackingToggle = false
    @State var adminPanelToggle = false
    
    @StateObject var authVM = AuthVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    // navigation links...
                    VStack {
                        NavigationLink(destination: LoginView().navigationBarHidden(true),
                                       isActive: $logoutToggle){}
                                       .hidden()
                        
                        NavigationLink(destination: SymptomsView().environmentObject(authVM),
                                       isActive: $diseaseViewToggle){}
                                       .hidden()
                        
                        NavigationLink(destination: AssessmentsView(),
                                       isActive: $assessmentToggle){}
                                       .hidden()
                        
                        NavigationLink(destination: ProfileView(),
                                       isActive: $profileToggle){}
                                       .hidden()
                        
                        NavigationLink(destination: WebView(url: "https://www.who.int"),
                                       isActive: $webViewToggle){}
                                       .hidden()
                        NavigationLink(destination: AdminHomeView().navigationBarHidden(true),
                                       isActive: $adminPanelToggle){}
                                       .hidden()
                    }
                    
                    if deviceHeight < 700 { Spacer() }
                    
                    // message...
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("**Welcome!**")
                                .font(.title3)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Hello \(authVM.fullName),")
                                Text("I can help you uncover what may be causing your symptoms. Just start a new symptom assessment.")
                                    .lineSpacing(2)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    // setps cards and arrows...
                    VStack {
                        // Steps card.1
                        StepsCardView(title: "STEP 1", description: "Selecting A Symptom", icon: "symptoms")
                            .padding(.top, 15)
                        
                        // arrow leading.
                        HStack {
                            Image(systemName: "arrow.down")
                                .font(deviceHeight > 780 ? .title2 : .body)
                                .padding(.leading,30).padding(.vertical,1)
//                                .foregroundColor(secondaryColor)
                            
                            Spacer()
                        }
                        
                        // Steps card.2
                        StepsCardView(title: "STEP 2", description: "Answering Questions", icon: "decision-making")
                            .padding(.top, deviceHeight > 780 ? 15 : 0)
                        
                        // arrow trailing.
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.down")
                                .font(deviceHeight > 780 ? .title2 : .body)
                                .padding(.trailing,30).padding(.vertical,1)
//                                .foregroundColor(secondaryColor)
                        }
                        
                        // Steps card.3
                        StepsCardView(title: "STEP 3", description: "Possible Causes", icon: "infection-cause")
                            .padding(.top, deviceHeight > 780 ? 15 : 0)
                    }
                    
                    Spacer()
                    
                    // Buttons...
                    VStack {
                        Button(action: {
                            diseaseViewToggle.toggle()
                        }, label: {
                            HStack {
                                Spacer()
                                ReusableButton(title: "Start Assessment", maxHeigh: 50)
                                    .padding(.horizontal, 60)
                                Spacer()
                            }
                        })
                            .padding(.top, deviceHeight < 700 ? 0:16)
                            .padding(.bottom, deviceHeight < 700 ? 10:0)
                    }
                    
                    Spacer()
                }
                .background(appColor)
                .blur(radius: authVM.fullName.isEmpty ? 6:0)
                .alert(isPresented: $logoutAlert) {
                    Alert(title: Text("Logout?"),
                          message: Text("Are you sure you want to logout?"),
                          primaryButton: .default(Text("Logout")) {
                        try! Auth.auth().signOut()
                        logoutToggle.toggle()
                        
                    }, secondaryButton: .destructive(Text("Cencel")))
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            selectedOption = ""
                            isShowingSheet.toggle()
                        } label: {
                            Image(systemName: "list.bullet.circle")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("EDOCTOR")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                    }
                }
                .sheet(isPresented: $isShowingSheet, onDismiss: {
                    if selectedOption == "logout" {
                        logoutAlert = true
                        
                    } else if selectedOption == "profile" {
                        profileToggle.toggle()
                        
                    } else if selectedOption == "webView" {
                        webViewToggle.toggle()
                        
                    } else if selectedOption == "assessmentsView" {
                        assessmentToggle.toggle()
                    } else if selectedOption == "admin" {
                        adminPanelToggle.toggle()
                    } else {  /*just closed...*/}
                }, content: {
                    NavbarView(selectedOption: $selectedOption)
                })
                
                if authVM.fullName.isEmpty {
                    LoadingView()
                }
            }
            
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            authVM.getUserProfile()
        }
    }
}


struct NavbarView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Binding var selectedOption: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .overlay(Circle().stroke(lineWidth: 3))
                            .foregroundColor(.white)
                        
                        Spacer()
                        Text("Menu")
                            .font(.title2)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                
                
                Spacer()
                
                Image(systemName: "xmark")
                    .onTapGesture {
                        selectedOption = ""
                        mode.wrappedValue.dismiss()
                    }
                
            }
            .font(.title2)
            .frame(maxHeight: 60)
            .foregroundColor(.white)
            .padding([.leading, .trailing])
            .padding(.top, 20)
            .background(navigationColor)
            
            VStack(alignment: .leading) {
                Text("USER")
                    .padding(.leading).padding(.top, 20)
                    .opacity(0.55)
                NavbarItemview(title: "My profile", icon: "person.fill")
                    .onTapGesture {
                        selectedOption = "profile"
                        mode.wrappedValue.dismiss()
                    }
                
                NavbarItemview(title: "Assessments", icon: "note.text")
                    .onTapGesture {
                        selectedOption = "assessmentsView"
                        mode.wrappedValue.dismiss()
                    }
                
                NavbarItemview(title: "Read WHO website", icon: "link")
                    .onTapGesture {
                        selectedOption = "webView"
                        mode.wrappedValue.dismiss()
                    }
                
                NavbarItemview(title: "Logout", icon: "square.and.arrow.up")
                    .onTapGesture {
                        selectedOption = "logout"
                        mode.wrappedValue.dismiss()
                    }
            }
            
            VStack(alignment: .leading) {
                Text("Admin")
                    .padding(.leading).padding(.top, 20)
                    .opacity(0.55)
                NavbarItemview(title: "Admin Panel", icon: "person.fill.checkmark")
                    .onTapGesture {
                        selectedOption = "admin"
                        mode.wrappedValue.dismiss()
                    }
            }
            
            Spacer()
        }
        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
        .background(appColor)
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



struct NavbarItemview: View {
    
    var title = "Profile"
    var icon = ""
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .background(appColor2)
        .overlay(RoundedRectangle(cornerRadius: 100)
                    .stroke(lineWidth: 1)
                    .foregroundColor(appColor))
        
        .cornerRadius(100)
        .padding([.leading, .trailing])
        .padding(.bottom, 4)
    }
    
}


struct StepsCardView: View {
    
    var title: String = "STEP 1"
    var description: String = "Selecting A Symptom"
    var icon: String = "symptoms"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(navigationColor, lineWidth: 0.5)
                .frame(height: 90)
                .padding([.leading, .trailing], 15)
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .padding(.bottom, 1)
//                        .foregroundColor(secondaryColor)
                    
                    Text(description)
                        .font(.body)
//                        .foregroundColor(secondaryColor)
                    //                        .bold()
                }
                
                Spacer()
                
                Image(icon)
                    .padding(5)
            }
            .padding([.leading, .trailing], 35)
        }
    }
}
