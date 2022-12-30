//
//  FeedbackView.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/18/21.
//

import SwiftUI

struct FeedbackView: View {
    
    @State private var feedbackTexts = ""
    @State private var skipClicked = false
    
    @StateObject var authVM = AuthVM()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
        VStack(alignment: .leading, spacing: 30) {
            
            // Navigation links.........
            NavigationLink(destination: AssessmentNotificationView().navigationBarBackButtonHidden(true),
                           isActive: $skipClicked){}
                           .hidden()
            //
            
            ScrollView {
                
                    Image("LOGO")
                        .padding(.leading)
                        .padding(.bottom, 32)
                    
                    Spacer(minLength: 40)
                
                
                VStack(spacing: 70) {
                    ReusableTextEditor(title: "We would love to know how we could do even better. Please let us know what could be improved.",
                                       placeholder: "Type here...",
                                       editorHeight: 170,
                                       editorFor: $feedbackTexts)
                 
                    
                    HStack(spacing: 50) {
                        Spacer()
                        
                        Text("Send")
                            .bold()
                            .padding([.leading, .trailing]).padding(10)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(100)
                            .onTapGesture {
                                authVM.sendFeedback(feedback: feedbackTexts)
                            }
                        
                        Text("Skip")
                            .bold()
                            .padding([.leading, .trailing]).padding(10)
                            .foregroundColor(.white)
                            .background(navigationColor)
                            .cornerRadius(100)
                            .onTapGesture {
                                withAnimation {
                                    skipClicked.toggle()
                                } }
                        
                        Spacer()
                    }
                }
            }
            Spacer()
            
                .navigationTitle("Feedback!")
                .navigationBarTitleDisplayMode(.inline)
        }
        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
        .background(appColor)
        .blur(radius: authVM.loading ? 6:0)
        .onTapGesture {
            self.hideKeyboard()
        }
        .alert(isPresented: $authVM.feedbackSentToggle) {
            Alert(title: Text("Submitted"), message: Text("Thanks for helping us to improve, your feedback saved successfully and we value your words."), dismissButton: .default(Text("Ok")) {
                withAnimation {
                    skipClicked.toggle()
                }
            })
        }
        
            if authVM.loading {
                LoadingView()
            }
    }
        .onAppear() {
            authVM.getUserProfile() // FOR email....
        }
    }
}

//FeedbackView
struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}

//struct AssessmentNotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AssessmentNotificationView()
//    }
//}


struct AssessmentNotificationView: View {
    
    @State private var okClicked = false
    @StateObject var authVM = AuthVM()
    
    var body: some View {
        ZStack {
        VStack(alignment: .leading, spacing: 30) {
            
            Spacer()
            
            Image("LOGO")
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Thank you \(authVM.fullName).")
                    .bold()
                    .padding(.bottom, 3)
                Text("We're done for now.\nYou can find your past assessments \nby clicking on Assessment \nTab in navigation items.")
                    .lineSpacing(5)
            }
            .padding(.leading)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    okClicked.toggle()
                    
                } label: {
                    ReusableButton(title: "Okay!")
                        .padding(.horizontal, 32)
                        .padding()
                }
            }
            
            Spacer()
            
                .navigationTitle("Information!")
                .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
        .background(appColor)
        .blur(radius: authVM.fullName.isEmpty ? 6:0)
        .fullScreenCover(isPresented: $okClicked) {
            HomeView()
        }
            
        
        if authVM.fullName.isEmpty {
            LoadingView()
        }
    }
        .onAppear {
            authVM.getUserProfile()
        }
    }
}
