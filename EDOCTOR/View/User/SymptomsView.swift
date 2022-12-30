//
//  DiseaseView.swift
//  EDOCTOR
//
//  Created by Maani on 10/23/21.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct SymptomsView: View {
    
    
    @StateObject var symptomsVM = SymptomsVM()
    @StateObject var qAVM = QAVM()
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var searchingSymptom: String = ""
    // for searching symptom int symptoms list....
    var searchResults: [SymptomsData] {
        if searchingSymptom.isEmpty {
            return symptomsVM.getSymptoms?.data ?? []
        } else {
            return (symptomsVM.getSymptoms?.data.filter {
                $0.name.localizedCaseInsensitiveContains(searchingSymptom)
            })!
        }
    }
    
    @State private var updatedAuthors: [SymptomsData] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            // Navigation links...
            NavigationLink(destination: QAView(selectedSymptom: symptomsVM.selectedSymptomID)
                            .navigationBarBackButtonHidden(true).environmentObject(qAVM),
                           isActive: $symptomsVM.QAViewToggle){}
                           .hidden()
            //
            
            // title text....
            Text("**Let's start with the symptom that's troubling you the most.**")
                .font(.title3)
                .padding(.horizontal).padding(.top, 32)
                .padding(.bottom, -20)
            
            // searching text field...
            ReusableTextField(tile: "",
                              placeholder: "Search symptom",
                              fieldldFor: $searchingSymptom,
                              thisCornersRadius: 100)
            
            // symptoms list....
            VStack {
                if !symptomsVM.apiResponseMessage.isEmpty {
                    HStack(alignment: .center) {
                        Spacer()
                        Text(symptomsVM.apiResponseMessage)
                            .font(.title2)
                            .opacity(0.4)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                        Spacer()
                    }
                } else {
                    
                    // if searching symptom did not match...
                    if searchResults.count <= 0 {
                        withAnimation {
                            HStack(alignment: .center) {
                                Spacer()
                                VStack {
                                    Text("Symptom not found!")
                                        .font(.title3)
                                        .padding(.top, 32)
                                    Text("Try again.")
                                        .underline()
                                        .font(.body)
                                        .opacity(0.8)
                                        .padding(.top, 5)
                                        .onTapGesture {
                                            withAnimation { searchingSymptom = "" }
                                        }
                                }
                                Spacer()
                            }
                        }
                    } else {
                        ScrollView {
                            ForEach(searchResults, id: \.self) { symp in
                                SymptomsViewCell(symptomsName: symp.name)
                                    .onTapGesture {
                                        symptomsVM.selectedSymptomID = symp.id
                                        qAVM.yesSymptoms.append(symp.name)
                                        symptomsVM.QAViewToggle.toggle()
                                    }
                            }
                        }
                    }
                    
                }
            }
            Spacer()
        }
        .background(appColor)
        .onAppear() {
            symptomsVM.getSymptomsApiRequest()
        }
        .alert(item: $symptomsVM.alertItem, content: { AlertItem in
            Alert(title: AlertItem.title,
                  message: AlertItem.message,
                  dismissButton: .default(Text("Okay!"))
            )
        })
        .navigationBarTitle("Symptoms")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomsView()
    }
}

struct SymptomsViewCell: View {
    
    @State var symptomsName: String = "Default"
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(appColor)
                    .frame(height: 50)
                    .shadow(color: .indigo, radius: 1)
                
                HStack {
                    Text(symptomsName)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                        .padding(.trailing)
                }
                .font(.body)
            }
            .padding(.top, 5)
            
            Spacer()
        }
        .padding([.leading, .trailing])
    }
}
