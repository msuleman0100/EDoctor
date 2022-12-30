//
//  QAView.swift
//  EDOCTOR
//
//  Created by Maani on 10/23/21.
//

import SwiftUI

struct QAView: View {
    
    @State var selectedSymptom = -1 // important
    
    @EnvironmentObject var qAVM: QAVM
    @State var search: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack {
                
                // navigation links
                NavigationLink(
                    destination: PossibleCausesView().navigationBarHidden(true)
                        .environmentObject(qAVM),
                    isActive: $qAVM.thankYouViewToggle){}
                    .hidden()
                //
                
                
                if qAVM.ifReleventSymptomsFound {
                    if qAVM.currentSymptomNumber < qAVM.totalSymptoms {
                        VStack(alignment: .leading) {
                            // progress bar
                            VStack {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(appColor2)
                                        .frame(maxWidth: deviceWidth, maxHeight: 20)
                                        .padding()
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(navigationColor)
                                        .frame(minWidth: 0, idealWidth: qAVM.currentProgress, maxWidth: qAVM.currentProgress, minHeight: 10, idealHeight: 10, maxHeight: 20)
                                        .padding()
                                }
                                .padding(.top, 32)
                                
                                HStack {
                                    Spacer()
                                    Text("\(Int(qAVM.currentSymptomNumber+1)) / \(Int(qAVM.totalSymptoms))")
                                        .font(.title2)
                                        .opacity(0.6)
                                    Spacer()
                                }
                            }
                            Spacer()
                            
                            // symptom and it's question....
                            VStack(alignment: .leading, spacing: 20) {
                                Text("**\(qAVM.symptomsList[Int(qAVM.currentSymptomNumber)].symptomName ?? "Symptom not found!")**")
                                    .font(.title2)
                                    .animation(.easeOut(duration: 0.8))
                                
                                Text("\(qAVM.symptomsList[Int(qAVM.currentSymptomNumber)].symptomQuestion ?? "Question not found!")")
                                    .font(.title3)
                                    .lineSpacing(10)
                                    .padding(.top, 32)
                                    .frame(maxWidth: deviceWidth, alignment: .leading)
                                    .animation(.easeOut(duration: 0.8))
                                let desc = qAVM.symptomsList[Int(qAVM.currentSymptomNumber)].symptomDescription ?? ""
                                if !desc.isEmpty {
                                    Text("What does this means?")
                                        .foregroundColor(.blue)
                                        .underline()
                                        .animation(.easeOut(duration: 0.8))
                                        .onTapGesture {
                                            qAVM.symptomDetailedSheetToggle.toggle()
                                        }
                                }
                            }
                            .frame(maxHeight: 300)
                            .padding()
                            
                            Spacer()
                            
                            // Buttons....
                            VStack {
                                // no button
                                Button {
                                    calculator(choice: "noClicked")
                                    
                                } label: {
                                    ReusableButton(title: "No", font: .title2)
                                        .padding(.horizontal)
                                }
                                .opacity(qAVM.currentSymptomNumber == qAVM.totalSymptoms ? 0.7:1)
                                .disabled(qAVM.currentSymptomNumber == qAVM.totalSymptoms ? true:false)
                                
                                // yes button
                                Button {
                                    calculator(choice: "yesClicked")
                                    
                                } label: {
                                    ReusableButton(title: "Yes", bgColor: Color.blue, font: .title2)
                                        .padding(.horizontal)
                                }
                                .opacity(qAVM.currentSymptomNumber == qAVM.totalSymptoms ? 0.7:1)
                                .disabled(qAVM.currentSymptomNumber == qAVM.totalSymptoms ? true:false)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: deviceWidth, alignment: .leading)
                        
                    } else {
                        VStack {
                            ThankyouView()
                                .environmentObject(qAVM)
                        }
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        .animation(Animation.easeInOut(duration: 1), value: 0)
                    }
                    
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Data couldn't fetched!")
                        Text("Seems that EDOCTOR's API is not responding at the moment, or you might be connected to a poor internet connection. If this error persist please contact support.")
                            .foregroundColor(.gray)
                    }
                    .padding([.leading, .top])
                }
                
                Spacer()
            }
            .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
            .background(appColor)
            .blur(radius: qAVM.loading ? 6:0)
            .opacity(qAVM.loading ? 0.7 : 1)
            
            if qAVM.loading {
                LoadingView()
            }
        }
        .onAppear() {
            qAVM.selectedSymptom = self.selectedSymptom // previusly selected symptom
            qAVM.getReleventSymptomsApiRequest()
        }
        .alert(item: $qAVM.alertItem, content: { AlertItem in
            Alert(title: AlertItem.title,
                  message: AlertItem.message,
                  dismissButton: .default(Text("Okay!"))
            )
        })
        .fullScreenCover(isPresented: $qAVM.symptomDetailedSheetToggle) {
            if qAVM.ruler == Rules.quitAssessment {
                HomeView()
            } else {
                symptomDetailedSheet()
                    .environmentObject(qAVM)
            }
        }
        
        .navigationBarTitle("New Assessment")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .onTapGesture {
                        qAVM.actionSheetTitle   = "Quit Assessment?"
                        qAVM.actionSheetMessage = "Once you quit the assessment, Your progress will be removed. Would you like to quit now?"
                        qAVM.actionSheetToggle.toggle()
                    }
            }
            
        }
        .actionSheet(isPresented: $qAVM.actionSheetToggle, content: {
            ActionSheet(title: Text(qAVM.actionSheetTitle),
                        message: Text(qAVM.actionSheetMessage),
                        buttons: [
                            .default(Text("Yes")) {
                                // for exit also...
                                qAVM.symptomDetailedSheetToggle.toggle()
                                qAVM.ruler = Rules.quitAssessment
                            },
                            .destructive(Text("Cancel"))
                        ])
            
        })
    }
    
    // action setting on buttons click for every symptom....
    func calculator(choice: String) {
        if qAVM.currentSymptomNumber < qAVM.totalSymptoms {
            
            // get current symptom from the symptomsList...
            let symptom = qAVM.symptomsList[Int(qAVM.currentSymptomNumber)]
            let diseaseID = symptom.diseaseID ?? "-1"
            
            // if yes clicked....
            if choice.elementsEqual("yesClicked") {
                
                qAVM.yesSymptoms.append(symptom.symptomName ?? "")
                
                if qAVM.diseaseIDsList.contains(Int(diseaseID)!) {
                    let previousSymptoms = qAVM.diseasesAndYesSymptoms["D\(diseaseID)"]
                    qAVM.diseasesAndYesSymptoms.updateValue(previousSymptoms!+1, forKey: "D\(diseaseID)")
                    
                } else {
                    qAVM.diseaseIDsList.append(Int(diseaseID)!)
                    qAVM.diseasesAndYesSymptoms["D\(diseaseID)"] = 1
                }
            }
            
            // if this is not the last symptom, move to the next one....
            if qAVM.currentSymptomNumber < qAVM.totalSymptoms {
                withAnimation {
                    qAVM.currentProgress += qAVM.perSymptomProgress
                    qAVM.currentSymptomNumber += 1
                }
            }
            
            // send disease and yes-Clicked symptoms count list to dectionaryToArray() for evaluation...
            if qAVM.currentSymptomNumber == qAVM.totalSymptoms {
                dectionaryToArray(dec: qAVM.diseasesAndYesSymptoms)
            }
            
        }
    }
    
    // to sort diseases and convert them into an array for further use...
    func dectionaryToArray(dec: [String : Int]) {
        
        // sorting diseases and it's yesClicked counting dectionary...
        let arr = dec.sorted {
            return $0.1 > $1.1
        }
        
        // converting dectionary to Array for further use....
        let arr2 = arr.map { "\($0.key) \($0.value)" }
        
        print("\n\nUnorderedList:   \(qAVM.diseaseIDsList)")
        qAVM.diseaseIDsList.removeAll() // make the diseasesIDs list empty to re-populate
        for d in arr2 {
            let dd = d.split(separator: " ", maxSplits: 1)
            var fd = dd.first
            _ = fd?.removeFirst(1)
            qAVM.diseaseIDsList.append(Int(fd ?? "-1")!)
        }
        print("\n\nOrderedList:   \(qAVM.diseaseIDsList)")
    }
    
}
extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

struct QAView_Previews: PreviewProvider {
    static var previews: some View {
//        symptomDetailedSheet()
        QAView()
    }
}

struct symptomDetailedSheet: View {
    
    @EnvironmentObject var qAVM: QAVM
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("**\(qAVM.symptomsList[Int(qAVM.currentSymptomNumber)].symptomName ?? "Detailed View")**")
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
            
            Text(qAVM.symptomsList[Int(qAVM.currentSymptomNumber)].symptomDescription ?? "Description not found!")
                .font(.title2)
                .padding()
            
            Spacer()
            
            Button {
                mode.wrappedValue.dismiss()

            } label: {
                ReusableButton(title: "Okay!", font: .title2)
                    .padding(.horizontal, 32)
            }

            
            
            Spacer()
        }
        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
        .background(appColor)
    }
}
