//
//  CreatedDiseaseView.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/2/22.
//

import SwiftUI

struct AdminDiseasesView: View {
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    @EnvironmentObject var adminVM: AdminVM
    //    @StateObject var adminVM = AdminVM()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var body: some View {
        ZStack {
            VStack {
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        
                        // disease name text field....
                        ReusableTextField(tile: "Disease name",
                                          placeholder: "e.g. Pneumonia",
                                          fieldldFor: $adminVM.disName)
                            .padding(.top, 32)
                            .onChange(of: adminVM.disName, perform: { _ in
                                detectChangesInDiseases()
                            })
                        
                        // key fact text field....
                        ReusableTextField(tile: "Key fact",
                                          placeholder: "e.g. Pneumonia can have more than 30 causes.",
                                          fieldldFor: $adminVM.disKeyfact)
                            .onChange(of: adminVM.disKeyfact, perform: { _ in
                                detectChangesInDiseases()
                            })
                        
                        // doctors-Link text field....
                        ReusableTextField(tile: "Doctor's link",
                                          placeholder: "e.g. doctors.com",
                                          fieldldFor: $adminVM.disDoctorsLink)
                            .onChange(of: adminVM.disDoctorsLink, perform: { _ in
                                detectChangesInDiseases()
                            })
                        
                        // reference-Link text field....
                        ReusableTextField(tile: "Reference link",
                                          placeholder: "e.g. who/pneumonia.com",
                                          fieldldFor: $adminVM.disReferenceLink)
                            .onChange(of: adminVM.disReferenceLink, perform: { _ in
                                detectChangesInDiseases()
                            })
                        
                        ReusableTextEditor(title: "Description",
                                           placeholder: "e.g. Pneumonia is an infection that inflames your lungs.",
                                           editorHeight: 100,
                                           editorFor: $adminVM.disDescription)
                            .onChange(of: adminVM.disDescription, perform: { _ in
                                detectChangesInDiseases()
                            })
                        
                        // symptoms disclosure...
                        if adminVM.diseaseID != -1 {
                            VStack(alignment: .leading) {
                                DisclosureGroup("**Symptoms**", isExpanded: $adminVM.expendSymptomsDisclosure) {
                                    
                                    let count = adminVM.getSymptomsByDiseaseIDResponse?.data.count ?? 0
                                    if !adminVM.getSymptomsByDiseaseIDToggle || count == 0 {
                                        VStack(spacing: 7) {
                                            Text("No symptoms found!")
                                                .font(.title3)
                                                .foregroundColor(.black)
                                            Text("Click the plus icon to add")
                                                .font(.caption)
                                        }
                                        .padding().padding(.top)
                                    } else {
                                        ForEach((adminVM.getSymptomsByDiseaseIDResponse?.data)!, id: \.self) { s in
                                            HStack {
                                                HStack {
                                                    SymptomListFieldView(symptom: s.symptomName ?? "")
                                                        .padding(.trailing)
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "pencil")
                                                        .font(.title2)
                                                        .foregroundColor(.black).opacity(0.7)
                                                        .padding(.top)
                                                }
                                                .onTapGesture {
                                                    adminVM.symptom_Id      = s.symptomID ?? "-1"
                                                    adminVM.sympName        = s.symptomName ?? ""
                                                    adminVM.symQuestion     = s.question ?? ""
                                                    adminVM.sympDescription = s.symptomDescription ?? ""
                                                    
                                                    adminVM.createSymptomToggle.toggle()
                                                }
                                                
                                                Button {
                                                    adminVM.ruler = Rules.deleteSingleSymptom
                                                    adminVM.selectedSymptomID = s.symptomID ?? "-1"
                                                    adminVM.actionSheetTile    = s.symptomName ?? "Delete Symptom?"
                                                    adminVM.actionSheetMessage = "This symptom will permanently deleted from database,\nwould you like to delete it now?"
                                                    adminVM.showConfirmationActionSheet.toggle()
                                                } label: {
                                                    Image(systemName: "minus.circle.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.red)
                                                        .padding(.top)
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    // add new symptom button...
                                    if count < 5 {
                                        HStack {
                                            Spacer()
                                            Button {
                                                adminVM.createSymptomToggle.toggle()
                                            } label: {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.blue)
                                            }
                                            
                                        }
                                        //                                    .padding(10)
                                        .padding(.top)
                                    }
                                }
                                .accentColor(.black)
                            }
                            .padding().padding(.vertical)
                        }
                        
                        
                        Spacer(minLength: 55)
                        
                        // add and update disease button...
                        if adminVM.diseaseID == -1 {
                            Button {
                                hideKeyboard() // for good UI...
                                if adminVM.diseaseID == -1 {
                                    // create new symptom....
                                    adminVM.ruler = Rules.addDisease
                                    adminVM.actionSheetTile    = "Add Disease?"
                                    adminVM.actionSheetMessage = "A new disease will be created with these information.\n Would you like to create it now?"
                                    adminVM.showConfirmationActionSheet.toggle()
                                    
                                } else {
                                    // update existing symptom...
                                    adminVM.ruler = Rules.updateDisease
                                    adminVM.actionSheetTile    = "Save changes?"
                                    adminVM.actionSheetMessage = "This disease will be updated with provided new informations.\ndo you want to save these changes?"
                                    adminVM.showConfirmationActionSheet.toggle()
                                }
                                
                            }
                        label: {
                            ReusableButton(title: adminVM.diseaseID == -1 ? "Add Disease" : "Save Changes")                        }
                        .opacity(adminVM.showDiseasesActonButton ? 1:0.6)
                        .disabled(adminVM.showDiseasesActonButton ? false:true)
                        }
                    }
                }
                
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
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
        .sheet(isPresented: $adminVM.createSymptomToggle, onDismiss: {
            // making these two variables empty incase we need to add another symptom right here...
            adminVM.symptom_Id      = "-1"
            adminVM.sympName        = ""
            adminVM.symQuestion     = ""
            adminVM.sympDescription = ""
        }, content: {
            AdminSymptomsView().environmentObject(adminVM)
        })
        .actionSheet(isPresented: $adminVM.showConfirmationActionSheet, content: {
            ActionSheet(title: Text(adminVM.actionSheetTile),
                        message: Text(adminVM.actionSheetMessage),
                        buttons: [
                            .default(Text("Yes")) {
                                
                                if adminVM.ruler == Rules.addDisease {
                                    print("create")
                                    adminVM.createDiseasesApiRequest()
                                    
                                } else if adminVM.ruler == Rules.updateDisease {
                                    adminVM.ruler = Rules.defaultRule
                                    print("updated")
                                    adminVM.updateDiseasesApiRequest()
                                    
                                } else if adminVM.ruler == Rules.deleteSingleSymptom {
                                    print("delete")
                                    adminVM.deleteSymptomsApiRequest()
                                } else {
                                    
                                }
                            },
                            .destructive(Text("Cancel"))
                        ])
            
        })
        .alert(item: $adminVM.alertItem, content: { item in
            Alert(title: item.title,
                  message: item.message,
                  dismissButton: .default(Text("Ok")))
        })
        .onAppear(){
            if adminVM.diseaseID != -1 {
                adminVM.getSymptomsByDiseaseIDApiRequest() // getting symptoms of selected disease
                
                // saving for comparing with changing informations in disease....
                adminVM.detectChangesInDiseases.append(adminVM.disName)
                adminVM.detectChangesInDiseases.append(adminVM.disKeyfact)
                adminVM.detectChangesInDiseases.append(adminVM.disDescription)
                adminVM.detectChangesInDiseases.append(adminVM.disDoctorsLink)
                adminVM.detectChangesInDiseases.append(adminVM.disReferenceLink)
                
                /// for setting visibility of showDiseasesActonButton
                /// this should be after above appends to detectChanges array.
                detectChangesInDiseases()
            }
        }
        .onDisappear() {
            // making this array empty for using next time...
            adminVM.detectChangesInDiseases.removeAll()
        }
        
        // toolbar Items...
        .toolbar {
            
            // View title....
            ToolbarItem(placement: .principal) {
                Text(adminVM.diseaseID == -1 ? "New Disease" : adminVM.disName.isEmpty ? "Deatiled View" : adminVM.disName)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            
            // add disease button....
            ToolbarItem(placement: .navigationBarTrailing) {
                if adminVM.diseaseID != -1 {
                    Button {
                        hideKeyboard() // for good UI...
                        if adminVM.diseaseID == -1 {
                            // create new symptom....
                            adminVM.ruler = Rules.addDisease
                            adminVM.actionSheetTile    = "Add Disease?"
                            adminVM.actionSheetMessage = "A new disease will be created with these information.\n Would you like to create it now?"
                            adminVM.showConfirmationActionSheet.toggle()
                            
                        } else {
                            // update existing symptom...
                            adminVM.ruler = Rules.updateDisease
                            adminVM.actionSheetTile    = "Save changes?"
                            adminVM.actionSheetMessage = "This disease will be updated with provided new informations.\ndo you want to save these changes?"
                            adminVM.showConfirmationActionSheet.toggle()
                            
                        }
                        
                    }
                label: {
                    Text(adminVM.diseaseID == -1 ? "Add" : "Save")
                        .bold()
                        .foregroundColor(.white)
                }
                .opacity(adminVM.showDiseasesActonButton ? 1:0.6)
                .disabled(adminVM.showDiseasesActonButton ? false:true)
                    
                }
            }
            
        }
    }
    
    func detectChangesInDiseases() {
        if adminVM.diseaseID == -1 {
            if  adminVM.disName.isEmpty || adminVM.disDescription.isEmpty ||
                    adminVM.disKeyfact.isEmpty || adminVM.disReferenceLink.isEmpty {
                adminVM.showDiseasesActonButton = false
                
            } else { adminVM.showDiseasesActonButton = true }
            
        } else {
            if adminVM.detectChangesInDiseases[0] != adminVM.disName ||
                adminVM.detectChangesInDiseases[1] != adminVM.disKeyfact ||
                adminVM.detectChangesInDiseases[2] != adminVM.disDescription ||
                adminVM.detectChangesInDiseases[3] != adminVM.disDoctorsLink ||
                adminVM.detectChangesInDiseases[4] != adminVM.disReferenceLink {
                adminVM.showDiseasesActonButton = true
                
            } else { adminVM.showDiseasesActonButton = false }
        }
    }
}

struct AdminDiseasesView_Previews: PreviewProvider {
    static var previews: some View {
        //        symptomTextFieldView()
        AdminDiseasesView()
    }
}

struct SymptomListFieldView: View {
    
    var symptom: String = "Symptom name"
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "arrow.turn.down.right")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    Text(symptom)
                        .lineLimit(1)
                }
            }
            .padding([.leading, .top])
        }
        .background(appColor) // for making it clickable outside of content
    }
}
