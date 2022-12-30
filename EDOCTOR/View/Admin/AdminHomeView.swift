//
//  AdminHome.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/2/22.
//

import SwiftUI

struct AdminHomeView: View {
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(navigationColor)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(.white)]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        UINavigationBar.appearance().tintColor = UIColor(.white)
    }
    
    @StateObject var adminVM = AdminVM()
    @State var selectedDis: DiseasesData?
    @Environment(\.presentationMode) var mode: Binding<PresentationMode> // to back to user Mode....
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                // navigation link...
                NavigationLink(destination: AdminDiseasesView().environmentObject(adminVM),
                    isActive: $adminVM.diseasesViewToggle){}
                    .hidden()
                
                // top view....
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome")
                            .font(.title2)
                            .bold()
                        Text("Hope you are doing well!")
                            .font(.body)
                            .opacity(0.55)
                    }
                    .padding([.top, .leading]).padding(.vertical, 10)
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    if !adminVM.apiResponseMessage.isEmpty {
                        HStack(alignment: .center) {
                            Spacer()
                            Text(adminVM.apiResponseMessage)
                                .font(.title2)
                                .opacity(0.4)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            ForEach(adminVM.getDiseasesResponse!.data, id: \.self) { dis in
                                DiseaseCellView(disease: dis)
                                    .padding(.top)
                                    .onTapGesture {
                                        // goto detailed/update view....
                                        adminVM.diseaseID = dis.id
                                        adminVM.disName = dis.name ?? ""
                                        adminVM.disDescription = dis.datumDescription ?? ""
                                        adminVM.disKeyfact = dis.keyFact ?? ""
                                        adminVM.disDoctorsLink = dis.doctorLink ?? ""
                                        adminVM.disReferenceLink = dis.refrenceLink ?? ""
                                        adminVM.diseasesViewToggle.toggle()
                                    }
                                    .onLongPressGesture(perform: {
                                        // show popup for delete....
                                        adminVM.diseaseID = dis.id
                                        adminVM.ruler = Rules.deleteDisease
                                        
                                        adminVM.actionSheetTile    = dis.name ?? "Delete?"
                                        adminVM.actionSheetMessage = "\(dis.name ?? "This disease") and it's 'Symptoms' will permanently deleted from database, would you like to delete it now?"
                                        adminVM.showConfirmationActionSheet.toggle()
                                    })
                            }
                            .padding()
                        }
                    }
                }
                
                Spacer()
            }
            .background(appColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "arrowshape.turn.up.backward.2")
                        .font(.title3)
                        .foregroundColor(.white)
                        .onTapGesture {
                            mode.wrappedValue.dismiss()
                        }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("EDOCTOR")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "plus.square.fill.on.square.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .onTapGesture {
                                adminVM.diseaseID = -1
                                adminVM.disName = ""
                                adminVM.disDescription = ""
                                adminVM.disKeyfact = ""
                                adminVM.disDoctorsLink = ""
                                adminVM.disReferenceLink = ""
                                adminVM.diseasesViewToggle.toggle()
                            }
                }
            }
            .actionSheet(isPresented: $adminVM.showConfirmationActionSheet, content: {
                ActionSheet(title: Text(adminVM.actionSheetTile),
                           message: Text(adminVM.actionSheetMessage),
                           buttons: [
                            .default(Text("Yes")) {
                                if adminVM.ruler == Rules.deleteDisease {
                                    adminVM.getSymptomsByDiseaseIDApiRequest()
                                }
                            },
                            .destructive(Text("Cancel")) {
                                adminVM.ruler     = Rules.defaultRule // ressetting ruller
                                adminVM.diseaseID = -1 // resetting selected diseaseID
                                
                            }
                           ])
                
            })
            .alert(item: $adminVM.alertItem) { item in
                Alert(title: item.title,
                      message: item.message,
                      dismissButton: .default(Text("Ok")) {
                    if adminVM.ruler == Rules.deleteDisease {
                        adminVM.ruler = Rules.defaultRule // resetting...
                        adminVM.deleteDiseasesApiRequest()
                        
                    }
                }
                )
            }
            
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            adminVM.ruler = Rules.getDiseases
            adminVM.getDiseasesApiRequest()
        }
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomeView()
    }
}
