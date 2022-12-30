//
//  AdminVM.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/2/22.
//

import Foundation
import SwiftUI
import Alamofire
import RealmSwift

final class AdminVM: UIViewController, ObservableObject, serverResponseData  {
    
    // MARK: Properties....
    
    
    @Published var getDiseasesResponse: GetDiseasesResponse? = nil
    @Published var getSymptomsByDiseaseIDResponse: GetSymptomsByDiseaseIDResponse? = nil
    
    // alert and loading view....
    @Published var alertItem : AlertItem?
    @Published var loading = false
    
    // required also...
    @Published var apiResponseMessage = "Retrieving disease..."
    @Published var ifDiseaseCreatedSuccessFully = false
    @Published var actionSheetTile = ""
    @Published var actionSheetMessage = ""
    
    // for adding disease...
    @Published var diseaseID = -1 // will need for adding symptom to a specific disease...
    @Published var disName = ""
    @Published var disKeyfact = ""
    @Published var disDescription = ""
    @Published var disDoctorsLink = ""
    @Published var disReferenceLink = ""
    
    // for adding symptom....
    @Published var symptom_Id = "-1"
    @Published var sympName = ""
    @Published var symQuestion = ""
    @Published var sympDescription = ""
    @Published var selectedSymptomID = "-1"
    @Published var deletedSymptomsCounter: Int = 0
    
    // for navigations, disclosures and api hitting status etc....
    @Published var diseasesViewToggle = false
    @Published var createSymptomToggle = false
    @Published var getSymptomsByDiseaseIDToggle = false
    @Published var expendSymptomsDisclosure = true // expended first time...
    
    // detecting changes in disease/symprom, and then show/hide their action Buttons accordingly...
    @Published var detectChangesInDiseases: [String] = []
    @Published var detectChangesInSymptoms: [String] = []
    @Published var showDiseasesActonButton = false
    @Published var showSymptomsActonButton = false
    
    // for multiButtons actionSheet...
    @Published var showConfirmationActionSheet = false
    @Published var ruler = Rules.defaultRule // this set the rules for different acitons....
    
    
    
//  MARK: API Requests....
    
    func deleteDiseasesApiRequest() {
        if diseaseID == -1 {
            self.alertItem = AlertContext.errorMessage(message: "Invalid disease to be deleted, please contact support")
            return
        }
        
        withAnimation { self.apiResponseMessage = "Deleting..." }
        loading = true
        let params: [String: Any] = ["disease_id": self.diseaseID]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.deleteDisease,
                                           params: params,
                                           method: .post,
                                           type: "deleteDiseasesApiRequest"
        )
        print("Disease-ID:   \(diseaseID)")
    }
    
    func deleteSymptomsApiRequest() {
        if selectedSymptomID == "-1" {
            self.alertItem = AlertContext.errorMessage(message: "Invalid symptom ID")
            return
        }
        loading = true
        let params: [String: Any] = ["symptom_id": self.selectedSymptomID]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.deleteSymptoms,
                                           params: params,
                                           method: .post,
                                           type: "deleteSymptomsApiRequest"
        )
    }
    
    func updateSymptomsApiRequest() {
        
        loading = true
        let params: [String: Any] = ["symptom_id"   : self.symptom_Id,
                                     "name"         : self.sympName,
                                     "question"     : self.symQuestion,
                                     "description"  : self.sympDescription
        ]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.updateSymptoms,
                                           params: params,
                                           method: .post,
                                           type: "updateSymptomsApiRequest"
        )
    }
    
    func updateDiseasesApiRequest() {
        loading = true
        let params: [String: Any] = ["disease_id"   : self.diseaseID,
                                     "name"         : self.disName,
                                     "description"  : self.disDescription,
                                     "key_Fact"     : self.disKeyfact,
                                     "doctor_link"  : self.disDoctorsLink,
                                     "refrence_link": self.disReferenceLink
        ]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.updateDisease,
                                           params: params,
                                           method: .post,
                                           type: "updateDiseasesApiRequest"
        )
    }
    
    func getSymptomsByDiseaseIDApiRequest() {
        //        loading = true
        
        if diseaseID == -1 {
            alertItem = AlertContext.errorMessage(message: "Invalid disease ID.")
            alertItem = AlertContext.errorMessage(message: "ID:   \(diseaseID)")
            return
        }
        let params: [String: Any] = ["disease_id": self.diseaseID]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.getSymptomsByDiseaseID,
                                           params: params,
                                           method: .post,
                                           type: "getSymptomsByDiseaseIDApiRequest"
        )
    }
    
    func createSymptomApiRequest() {
        
        if sympName.isEmpty || symQuestion.isEmpty {
            self.alertItem = AlertContext.errorMessage(message: "Please provide valid data.")
            return
        }
        
        loading = true
        
        let params: [String: Any] = ["name" : sympName,
                                     "disease_id": self.diseaseID,
                                     "question"    : self.symQuestion,
                                     "description": sympDescription]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.createSymptoms,
                                           params: params,
                                           method: .post,
                                           type: "createSymptomApiRequest"
        )
    }
    
    func createDiseasesApiRequest() {
        
        if disName.isEmpty || disDescription.isEmpty ||
            disKeyfact.isEmpty || disReferenceLink.isEmpty {
            self.alertItem = AlertContext.errorMessage(message: "Please provide valid data to create new disease")
            return
        }
        
        loading = true
        
        let params: [String: Any] = ["name"         : self.disName,
                                     "description"  : self.disDescription,
                                     "key_Fact"     : self.disKeyfact,
                                     "doctor_link"  : self.disDoctorsLink,
                                     "refrence_link": self.disReferenceLink
        ]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.createDiseases,
                                           params: params,
                                           method: .post,
                                           type: "createDiseasesApiRequest"
        )
    }
    
    func getDiseasesApiRequest() {
        loading = true
        
        let params: [String: Any] = [:]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.getDiseases,
                                           params: params,
                                           method: .get,
                                           type: "getDiseasesApiRequest"
        )
    }
    
    
//  MARK: OnsSuccess of API Requests....
    func onSuccess(data: Data, val: String) {
        loading = false
        switch val {
            
        case "deleteDiseasesApiRequest":
            print("\n\nDisease deleted....\n\n")
            ruler = Rules.defaultRule // resetting ruller.....
            // will populate with updated diseases list....
            self.getDiseasesResponse = nil
            self.getDiseasesApiRequest()
            break
            
        case "deleteSymptomsApiRequest":
            
            if ruler == Rules.deleteSingleSymptom {
                ruler = Rules.defaultRule
                getSymptomsByDiseaseIDApiRequest()
                print("\n\nSym-ID:   \(self.selectedSymptomID)   Deleted.....")
            }
            else if ruler == Rules.deleteDisease {
                print("\n\nSym-ID:   \(self.selectedSymptomID)   Deleted.....")
                
                deletedSymptomsCounter += 1
                
                if deletedSymptomsCounter < self.getSymptomsByDiseaseIDResponse?.data.count ?? 0 {
                    self.selectedSymptomID = self.getSymptomsByDiseaseIDResponse?.data[deletedSymptomsCounter].symptomID ?? "-1"
                    self.deleteSymptomsApiRequest()
                    //                print("Sym-ID:  \(self.selectedSymptomID)   deleted....")
                } else {
                    deleteDiseasesApiRequest()
                    print("\n\nAll symptoms Deleted.....")
                }
            } else {
                print("something went wrong!")
            }
            
            break
            
            // update symptoms....
        case "updateSymptomsApiRequest":
            ruler = Rules.symptomUpdatedSuccess
            self.alertItem = AlertContext.successMessage(title: "Saved!",
                                                         message: "Changes successfully saved to this symptom.")
            // for getting latest changes in selected disease...
            getSymptomsByDiseaseIDApiRequest()
            
            break
            
            // update disease....
        case "updateDiseasesApiRequest":
            print("Changes successfully saved to this disease.")
            self.ruler = Rules.getDiseases
            getDiseasesApiRequest()
            break
            
            // get symptom by disease-ID....
        case "getSymptomsByDiseaseIDApiRequest":
            do {
                self.getSymptomsByDiseaseIDResponse = try JSONDecoder().decode(GetSymptomsByDiseaseIDResponse.self, from: data)
                if ruler == Rules.deleteDisease {
                    withAnimation { apiResponseMessage = "Deleting..." }
                    if self.getSymptomsByDiseaseIDResponse?.data.count ?? 0 > 0 {
                        self.selectedSymptomID = self.getSymptomsByDiseaseIDResponse?.data[deletedSymptomsCounter].symptomID ?? "-1"
                        self.deleteSymptomsApiRequest()
                    } else {
                        print("Disease don't have any symptoms")
                        self.deleteDiseasesApiRequest()
                    }
                }  else {
//                    print("SympID:  \(selectedSymptomID) deteled....")
                    getSymptomsByDiseaseIDToggle = true
                }
            } catch {
                print(error.localizedDescription)
                self.alertItem = AlertContext.errorMessage(message: error.localizedDescription)
            }
            break
            
            // create new symptom....
        case "createSymptomApiRequest":
            ruler = Rules.symptomAddedSuccess
            self.alertItem = AlertContext.successMessage(title: "Added!", message: "Symptom added successfully")
            // for getting latest changes in selected disease...
            getSymptomsByDiseaseIDApiRequest()
            break
            
            // create new disease....
        case "createDiseasesApiRequest":
                // for updating home view diseases list...
                self.ruler = Rules.getDiseases
            showDiseasesActonButton.toggle() // for preventing extra clicks on add desease button....
                getDiseasesApiRequest()
                self.alertItem = AlertContext.successMessage(title: "Added successfully!",
                                                             message: "Disease successfully added, Tap this disease in Home-View for adding Symptoms.")
                break
            
            // get diseases list....
        case "getDiseasesApiRequest":
            do {
                self.getDiseasesResponse = try JSONDecoder().decode(GetDiseasesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.ruler = Rules.defaultRule // again going back to home
                    withAnimation { self.apiResponseMessage = "" }
                }
            } catch {
                ruler = Rules.defaultRule
                self.apiResponseMessage = "Diseases couldn't loaded"
                print(error.localizedDescription)
                self.alertItem = AlertContext.errorMessage(message: error.localizedDescription)
            }
            break
            
        default:
            break
        }
    }
    
//  MARK: OnsFailure of API Requests....
    func onFailure(message: String) {
        loading = false
        print("OnFailure" + message)
        self.alertItem = AlertContext.errorMessage(message: message)
        if ruler == Rules.getDiseases {
            ruler = Rules.defaultRule
            self.apiResponseMessage = "Diseases couldn't loaded\n \(message) " // home view msg if diseases didn't loaded...
        }
    }
    
}


struct Rules {
    
    static let defaultRule   = 0
    
    // admin action sheet....
    static let addDisease    = 1
    static let updateDisease = 2
    static let deleteSingleSymptom = 3
    static let deleteDisease = 4
    static let deleteAllSymptomsOfDisease = 5
    
    // symptom update success....
    static let symptomAddedSuccess   = 6
    static let symptomUpdatedSuccess = 7
    
    static let getDiseases   = 8
    
    
    // auth rules
    static let registerSuccess = 9
    static let loginSuccess = 10
    static let passwordResetted = 11
    
    // assessment Rules
    static let quitAssessment = 12
    static let reportsMakingIsInProgress = 13
    static let reportsDone   = 14
    
}
