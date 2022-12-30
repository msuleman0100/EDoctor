//
//  AssessmentsVM.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/19/21.
//

import SwiftUI
import Foundation

struct AssessmentsView: View {
    
    @State var numberOfAssessments = UserDefaults.standard
        .integer(forKey: UserDefaultKeys.assesNo)
    let userDefaults = UserDefaults.standard
    
    @State var diseaseDetailedViewToggle = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                if numberOfAssessments > 0 {
                    
                    ForEach(0..<numberOfAssessments) { i in
                        
                        let diseases = UserDefaults.standard.object(forKey: "\(UserDefaultKeys.diseases)\(numberOfAssessments-i)") as? [String] ?? []
                        let symptoms = UserDefaults.standard.object(forKey: "\(UserDefaultKeys.symptoms)\(numberOfAssessments-i)") as? [String] ?? []
                        let date = UserDefaults.standard.string(forKey: "\(UserDefaultKeys.date)\(numberOfAssessments-i)")
                        let time = UserDefaults.standard.string(forKey: "\(UserDefaultKeys.time)\(numberOfAssessments-i)")
                        
                        HStack {
                        HStack(alignment: .top) {
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(date ?? "Invalid date")
                                    .foregroundColor(secondaryColor)
                                
                                Text("\(diseases[0] )").bold()
                                
                                Text(time ?? "Invalid time").opacity(0.6)
                            }
                            .padding(.leading, 16)
                            
                            // Navigation links...
                            NavigationLink(destination: AssessmentDetailView(symptoms: symptoms , diseases: diseases ),
                                           isActive: $diseaseDetailedViewToggle){}
                                           .hidden()
                            //
                            
                        }
                            
                            Spacer()
                        
                            Image(systemName: "chevron.forward")
                    }
                        .padding()
                        .frame(maxWidth: deviceWidth)
                        .background(appColor2)
                        .cornerRadius(10)
                        .padding(.horizontal).padding(.bottom)
                        .onTapGesture {
                            diseaseDetailedViewToggle.toggle()
                        }
                        
                    }
                }
                else {
                    Text("No assessment history found")
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Assessments")
            .navigationBarTitleDisplayMode(.inline)
        }
        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
        .background(appColor)
        .onAppear() {
            numberOfAssessments = UserDefaults.standard
                .integer(forKey: UserDefaultKeys.assesNo)
        }
    }
}

struct AssessmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentsView()
    }
}

struct AssessmentDetailView: View {
    
    var symptoms: [String] = []
    var diseases: [String] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                VStack {
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
                .frame(maxWidth: deviceWidth-40, maxHeight: 120)
                .background(assessmentBoxColor)
                .cornerRadius(12)
                .padding(.top, 32)
                .shadow(color: .gray, radius: 1)
                
                
                // Diseases list....
                Text("Diseases")
                    .font(.title3)
                    .padding(.top, 32)
                
                ForEach(diseases, id: \.self) { sy in
                    VStack {
                        HStack(alignment: .top) {
                            Image(systemName: "circle.fill")
                                .font(.caption2)
                            
                            Text("\(sy)")
                                .font(.title3)
                        }
                        .padding(.leading)
                    }
                    .padding(.top, 10)
                }
                
                
                // Symtoms list....
                Text("Symptoms")
                    .font(.title2)
                    .padding(.top, 32)
                
                ForEach(symptoms, id: \.self) { sy in
                    VStack {
                        HStack(alignment: .top) {
                            Image(systemName: "circle.fill")
                                .font(.caption2)
                            
                            Text("\(sy)")
                                .font(.title3)
                            
                        }
                        .padding(.leading)
                    }
                    .padding(.top, 10)
                }
                
                VStack {
                    Capsule().stroke(style: StrokeStyle(lineWidth: 0.4, dash: [10]))
                        .frame(maxWidth: deviceWidth-40, maxHeight: 1)
                        .foregroundColor(.gray)
                        .padding(.top, 32)
                        .padding(.bottom, 10)
                }
                
                VStack {
                    Text("This list includs cautions that EDOCTOR has identified as possibe cause for your symptoms.  This is not a dignoses and is also not an exhastive list. You might have a condition that is not suggested here. Please consult a doctor if you are concerned about your health.")
                        .opacity(0.7)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: deviceWidth-40)
                }
                .padding([.top, .bottom])
                
                Spacer()
            }
        }
        .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
        .background(appColor)
    }
}
