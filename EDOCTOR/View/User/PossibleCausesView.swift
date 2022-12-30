//
//  PossibleCausesView.swift
//  EDOCTOR
//
//  Created by Maani on 10/24/21.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct PossibleCausesView: View {
    
    
    //    @StateObject var qAVM: QAVM
    @EnvironmentObject var qAVM: QAVM
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var diseaseDetailToggle = false
    @State var goToHome = false
    @State var feedbackToggle = false
    @State private var ifSymptomsShowingDisclosure = false
    
    @State var disName = ""
    @State var disDescription = ""
    @State var webViewToggle = false
    
    @State var ifDiseaseDeatiledViewToggle = false
    @State var ifDiseaseReeferenceAsked = false
    @State var diseaseReferenceLinkToggle = false
    @State var diseaseReferenceLink = ""
    
    var body: some View {
        ZStack {
            VStack {
                
                // Navigation links...
                NavigationLink(destination: FeedbackView().navigationBarBackButtonHidden(true),
                               isActive: $feedbackToggle){}
                               .hidden()
                NavigationLink(destination: WebView(url: diseaseReferenceLink),
                               isActive: $ifDiseaseReeferenceAsked){}
                               .hidden()
                //
                
                
                if qAVM.ifDiseaseFound {
                    // Box
                    VStack(alignment: .center) {
                        VStack(alignment: .center) {
                            Text("Feeling worried!")
                                .bold()
                                .padding(.top)
                                .padding(5)
                            
                            Text("Don't hasitate to seek care.")
                                .padding(.leading, 5)
                                .opacity(0.7)
                                .padding(.bottom)
                                .lineLimit(2)
                        }
                    }
                    .frame(maxWidth: deviceWidth-40, maxHeight: 120, alignment: .center)
                    .background(appColor2)
                    .cornerRadius(12)
                    .padding(.top, 32)
                    .shadow(color: .gray, radius: 1)
                    
                    Spacer()
                    
                    // if not a single symptom exist...
                    if qAVM.yesSymptoms.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("**Thankfully**")
                                .font(.title2)
                                .padding(.bottom, 5)
                            
                            Text("This time we don't have any bad news for you.")
                                .font(.title2)
                                .padding(.bottom)
                            Text("This is the indication of good health, Seems you'r fine.")
                                .font(.title2)
                            
                            
                            Text("EDOCTOR taking informations about Disease and it's symptoms from 'Centers for Disease Control and Prevention' Database.")
                                .font(.body)
                                .padding(.top, 60)
                            
                            HStack {
                                Spacer()
                                Button {
                                    diseaseReferenceLink = "https://www.cdc.gov"
                                    ifDiseaseReeferenceAsked.toggle()
                                } label: {
                                    ReusableButton(title: "Reference",
                                                   bgColor: .blue,
                                                   font: .title3, maxHeigh: 45, maxWidth: 140)
                                }

                            }
                            .padding(.top, 50)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
                        .background(appColor)
                    }
                    else {
                        
                        // if reports is not empty....
                        ScrollView(showsIndicators: false)  {
                            HStack {
                                Text("Possible Causes")
                                    .font(.title3)
                                    .opacity(0.55)
                                    .padding([.leading, .trailing, .top])
                                    .padding(.top)
                                
                                Spacer()
                            }
                            
                            ForEach(qAVM.finalDiseases, id: \.self) { disease in
                                
                                HStack(alignment: .top) {
                                    VStack {
                                        VStack(alignment: .leading, spacing: 3) {
                                            
                                            Text(disease.name ?? "Disease not found")
                                                .font(.title2)
                                            
                                            NavigationLink(destination: WebView(url: disease.doctorLink ?? "https://www.google.com/?client=safari")) {
                                                Text("Seek medical advice")
                                                    .font(.title3)
                                                    .foregroundColor(Color.indigo)
                                                    .opacity(disease.doctorLink?.isEmpty ?? false ? 0.6:1)
                                                    .disabled(disease.doctorLink?.isEmpty ?? false ? true:false)
                                            }
                                            
                                            Text(disease.keyFact ?? "default")
                                        }
                                        .frame(maxWidth: deviceWidth, alignment: .leading)
                                        .font(.system(size: 14))
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(secondaryColor, lineWidth: 1))
                                        .padding([.leading, .trailing])
                                        .padding(.top, 20)
                                        
                                        HStack {
                                            Spacer()
                                            Button {
                                                diseaseReferenceLink = disease.refrenceLink ?? "https://www.google.com/?client=safari"
                                                disName = disease.name ?? "Not found!"
                                                disDescription = disease.datumDescription ?? "Description not found!"
                                                diseaseDetailToggle.toggle()
                                            } label: {
                                                Text("**Tell me more**")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                                    .padding([.top, .bottom], 10)
                                                    .padding([.leading, .trailing])
                                                    .overlay(RoundedRectangle(cornerRadius: 20)
                                                                .stroke(secondaryColor, lineWidth: 1))
                                                    .padding([.trailing])
                                            }
                                        }
                                    }
                                }
                                
                                .padding(.bottom, 10)
                                Spacer()
                            }
//                            .padding(.horizontal)
//                            .padding(.horizontal, 5)
                            
                            DisclosureGroup("**Symptoms**", isExpanded: $qAVM.isSymptomsExpended) {
                                ForEach(qAVM.yesSymptoms, id: \.self) { symp in
                                    HStack(spacing: 10) {
                                        Image(systemName: "arrow.turn.down.right")
                                        Text(symp.capitalized)
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    .padding(.leading)
                                }
                                .padding(.top)
                            }
                            .accentColor(.black)
                            .padding().padding(.horizontal, 5)
                            
                            VStack {
                                Capsule().stroke(style: StrokeStyle(lineWidth: 0.4, dash: [10]))
                                    .frame(maxWidth: deviceWidth-40, maxHeight: 1)
                                    .foregroundColor(navigationColor)
                                    .padding(.top, 32)
                                    .padding(.bottom, 10)
                            }
                            
                            // message and continue button
                            VStack(alignment: .leading, spacing: 15) {
                                if qAVM.ifDiseaseFound {
                                    withAnimation {
                                        Text("This list includs cautions that EDOCTOR has identified as possibe cause for your symptoms.  This is not a dignoses and is also not an exhastive list. You might have a condition that is not suggested here. Please consult a doctor if you are concerned about your health.")
                                            .opacity(0.7)
                                            .padding(.horizontal, 5)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    Spacer()
                    
                    // continue button
                    HStack {
                        Spacer()
                        Button {
                            // save assessments if user have any symptoms else don't save it....
                            if qAVM.yesSymptoms.count > 0 {
                                qAVM.saveUserAssessment()
                            }
                            
                            feedbackToggle.toggle()
                        } label: {
                            ReusableButton(title: "Continue!",
                                           font: .title3, maxHeigh: 50)
                                .padding(.horizontal, 70)
                        }
                        Spacer()
                    }
                    .padding(1)
                    
                }
                else {
                    if qAVM.ruler != Rules.reportsMakingIsInProgress {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Reports couldn't displayed!")
                            Text("Seems that EDOCTOR's API is not responding at the moment, or you might be connected to a poor internet connection. If this error persist please contact support.")
                        }
                        .padding(.horizontal)
                        .padding(.top, 32)
                        .opacity(qAVM.ruler == Rules.reportsMakingIsInProgress ? 0:1)
                    }
                   
                }
                
                if qAVM.loading {  Spacer() }
                
                
            }
            .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
            .background(appColor)
            .blur(radius: qAVM.loading ? 4 : 0)
            .opacity(qAVM.loading ? 0.5 : 1)
            
            if qAVM.loading {
                VStack(spacing: 15) {
                    Text("**Please Hold On!**")
                        .font(.title2)

                    Text("I'm just arranging your reports.")
                        .font(.title2)
                        .padding(.bottom, 50)
                    
                    LoadingIndicator(animation: .threeBallsTriangle, color: navigationColor, size: .large, speed: .normal)
                }
            }
        }
        .onAppear(perform: {
            
            if qAVM.ruler == Rules.reportsDone {
                qAVM.loading = true
                qAVM.ruler = Rules.reportsMakingIsInProgress
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if !qAVM.ifDiseaseFound {
                    qAVM.getDiseasesApiRequest()
                }
            }
            
        })
        .sheet(isPresented: $diseaseDetailToggle) {
            DiseaseDetailedView(disName: $disName,
                                disDescription: $disDescription,
                                ifDiseaseReeferenceAsked: $ifDiseaseReeferenceAsked)
        }
        
        .navigationBarTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PossibleCausesView_Previews: PreviewProvider {
    static var previews: some View {
//        PossibleCausesView()
        
        VStack(alignment: .leading, spacing: 5) {
            Text("**Thankfully**")
                .font(.title2)
                .padding(.bottom, 5)
            
            Text("This time we don't have any bad news for you.")
                .font(.title2)
                .padding(.bottom)
            Text("This is the indication of good health, Seems you'r fine.")
                .font(.title2)
            
            
            Text("EDOCTOR taking informations from 'Centers for Disease Control and Prevention' about Disease and it's symptoms.")
                .font(.body)
                .padding(.top, 60)
            HStack {
                
                Spacer()
                ReusableButton(title: "Reference",
                               font: .title3, maxHeigh: 45, maxWidth: 150)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
        .background(appColor)
        
        
        //        DiseaseDetailedView(disName: .constant(""), disDescription: .constant(""), ifDiseaseReeferenceAsked: .constant(false))
    }
}


struct DiseaseDetailedView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Binding var disName: String
    @Binding var disDescription: String
    @Binding var ifDiseaseReeferenceAsked: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("**Description!**")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.leading, 60)
                
                Spacer()
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .onTapGesture {
                        mode.wrappedValue.dismiss()
                    }
            }
            .padding()
            .background(navigationColor)
            
            Spacer ()
            
            VStack(alignment: .leading) {
                Spacer ()
                Text(disName)
                    .font(.title2)
                    .padding(.leading)
                
                Text(disDescription)
                    .padding()
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                //  buttons...
                HStack {
                    Spacer()
                    Button(action: {
                        ifDiseaseReeferenceAsked = true
                        mode.wrappedValue.dismiss()
                    }, label: {
                        ReusableButton(title: "Tell me more",
                                       bgColor: appColor2,
                                       font: .title3,
                                       forGround: .black)
                    })
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            mode.wrappedValue.dismiss()
                        }, label: {
                            ReusableButton(title: "Close!",
                                           font: .title3)
                        })
                    }
                }
                
                Spacer()
            }
            .frame(alignment: .leading)
            Spacer()
        }
        .background(appColor)
    }
}
