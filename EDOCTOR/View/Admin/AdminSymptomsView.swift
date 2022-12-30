//
//  CreateSymptomView.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/2/22.
//

import SwiftUI

struct AdminSymptomsView: View {
    
    @EnvironmentObject var adminVM: AdminVM
//        @StateObject var adminVM = AdminVM()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            
                VStack {
                    // top view....
                    HStack {
                        Spacer()
                        Text(adminVM.symptom_Id == "-1" ? "Add Symptom" : "Update")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Button {
                            mode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: deviceWidth, maxHeight: 60)
                    .background(navigationColor)
                    
                    // body content...
                    ScrollView(showsIndicators: false) {
                    VStack {
                        
                        // symptom name field...
                        ReusableTextField(tile: "Symptom name",
                                    placeholder: "e.g. Loss of appetite",
                                    fieldldFor: $adminVM.sympName)
                            .padding(.top, 32)
                            .onChange(of: adminVM.sympName, perform: { _ in
                                detectChangesInSymptom()
                            })
                        
                        
                        // symptom question field...
                        ReusableTextEditor(title: "Question to ask",
                                     placeholder: "e.g. Do you feel loss of appetite?",
                                     editorHeight: 70,
                                     editorFor: $adminVM.symQuestion)
                            .padding(.top)
                            .onChange(of: adminVM.symQuestion, perform: { _ in
                                detectChangesInSymptom()
                            })
                        
                        // symptom description field...
                        ReusableTextEditor(title: "Description",
                                     placeholder: "e.g. Loss of appetite means you don't have the same desire to eat as you used to.",
                                     editorHeight: 100, editorFor: $adminVM.sympDescription)
                            .padding(.top)
                            .onChange(of: adminVM.sympDescription, perform: { _ in
                                detectChangesInSymptom()
                            })
                        
                        Spacer(minLength: 80)
                        
                        // Add/Update action Button
                        VStack {
                            Button {
                                if adminVM.symptom_Id == "-1" {
                                    // adding new symptom....
                                    adminVM.createSymptomApiRequest()
                                    
                                } else {
                                    // updating existing symptom...
                                    adminVM.updateSymptomsApiRequest()
                                }
                                
                            } label: {
                                ReusableButton(title: adminVM.symptom_Id == "-1" ? "Add Now" : "Save")
                            }
                            .opacity(adminVM.showSymptomsActonButton ? 1:0.6)
                            .disabled(adminVM.showSymptomsActonButton ? false:true)
                            
                        }
                    }
                    }
                }
                .background(appColor)
            
            .blur(radius: adminVM.loading ? 6:0)
            
            if adminVM.loading {
                LoadingView()
            }
        }
        .onTapGesture(perform: {
            hideKeyboard()
        })
        .onAppear(perform: {
            adminVM.detectChangesInSymptoms.append(adminVM.sympName)
            adminVM.detectChangesInSymptoms.append(adminVM.symQuestion)
            adminVM.detectChangesInSymptoms.append(adminVM.sympDescription)
            
            // for setting visibility of showSymptomsActonButton
            //  this should be after above appends to detectChanges array.
            detectChangesInSymptom()
        })
        .onDisappear(perform: {
            adminVM.detectChangesInSymptoms.removeAll()
        })
        .alert(item: $adminVM.alertItem) { item in
            Alert(title: item.title,
                  message: item.message,
                  dismissButton: .default(Text("OK")) {
                if adminVM.ruler == Rules.symptomAddedSuccess || adminVM.ruler == Rules.symptomUpdatedSuccess {
                    adminVM.ruler = Rules.defaultRule // resetting ruler...
                    mode.wrappedValue.dismiss()
                }
            })
        }
        
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    func detectChangesInSymptom() {
        if adminVM.symptom_Id == "-1" {
            // changes new symptom
            if  adminVM.sympName.isEmpty ||
                    adminVM.symQuestion.isEmpty {
                adminVM.showSymptomsActonButton = false
                
            } else { adminVM.showSymptomsActonButton = true }
            
        } else {
            // existing symptom changes...
            if adminVM.detectChangesInSymptoms [0] != adminVM.sympName ||
                adminVM.detectChangesInSymptoms[1] != adminVM.symQuestion
                || adminVM.detectChangesInSymptoms[2] != adminVM.sympDescription
            {
                adminVM.showSymptomsActonButton = true
                
            } else { adminVM.showSymptomsActonButton = false }
        }
    }
    
}

struct AdminSymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        AdminSymptomsView()
    }
}
