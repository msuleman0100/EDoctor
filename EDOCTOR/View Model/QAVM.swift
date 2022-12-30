//
//  SymptomsVM.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/12/21.
//

import Foundation
import SwiftUI
import Alamofire

final class QAVM: UIViewController, ObservableObject, serverResponseData  {
    
    // MARK: Properties
    
    @Published var orderDiseases: [String] = []
    @Published var previousSymptoms: [String] = []
    @Published var diseasesEvaluator:[String : Int] = [ : ]
    //rlkrkropkrkro farigh....
    
    @Published var getReleventSymptoms: GetSymptomsByIDResponse? = nil
    @Published var symptomsList: [GetSymptomsByIDResponseData] = []
    @Published var finalDiseases: [DiseasesData] = []
    @StateObject var authVM = AuthVM()
    
    // required....
    @Published var alertItem : AlertItem?
    @Published var loading = false
    @Published var watingMessage = "One moment..." // somthing in message while loading
    @Published var ruler = Rules.defaultRule
    
    @Published var ifReleventSymptomsFound = false
    @Published var ifDiseaseFound = false ///
    @Published var selectedSymptom = -1
    
    // navigation toggles...
    @Published var thankYouViewToggle = false
    @Published var symptomDetailedSheetToggle = false
    @Published var actionSheetTitle = ""
    @Published var actionSheetMessage = ""
    @Published var actionSheetToggle = false
    
    
    // for showing symptoms and po=rogress bar
    @Published var currentSymptomNumber: CGFloat = 0
    @Published var totalSymptoms: CGFloat = 0
    @Published var currentProgress: CGFloat = 0
    @Published var perSymptomProgress: CGFloat = 0
    @Published var maxProgress: CGFloat = deviceWidth //current device width in CGFloat for progress bar....
    
    
    
    // calculation for reports......
    @Published var diseasesAndYesSymptoms: [String : Int] = [:]
    @Published var diseaseIDsList:   [Int] = []
    @Published var yesSymptoms:   [String] = []
    
    
     @Published var assessmentDiseases = []
     @Published var assessmentSymptoms = []
     @Published var assessmentDate = ""
    @Published var isSymptomsExpended = true
    
    func saveUserAssessment() {
        
        let date = Date()
        let df = DateFormatter()
        
        df.dateFormat = "dd MMMM, yyyy"
        let dateString = df.string(from: date)
        
        df.dateFormat = "hh:mm aaa"
        let timeString = df.string(from: date)
        
        print("\n\nDate: \(dateString)")
        print("Time: \(timeString)")
        
        var assessementNo = UserDefaults.standard.integer(forKey: "\(UserDefaultKeys.assesNo)")
        print("last as no :  \(assessementNo)")
        assessementNo += 1
        
        UserDefaults.standard.set(dateString, forKey: "\(UserDefaultKeys.date)\(assessementNo)")
        UserDefaults.standard.set(timeString, forKey: "\(UserDefaultKeys.time)\(assessementNo)")
        
        UserDefaults.standard.set(self.orderDiseases, forKey: "\(UserDefaultKeys.diseases)\(assessementNo)")
        UserDefaults.standard.set(self.yesSymptoms, forKey: "\(UserDefaultKeys.symptoms)\(assessementNo)")
        
        UserDefaults.standard.set(assessementNo, forKey: "\(UserDefaultKeys.assesNo)")
    }
    
    func getReleventSymptomsApiRequest() {
        loading = true
        
        let params: [String: Any] = ["symptom_id": selectedSymptom]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.getSymptomsByID,
                                           params: params,
                                           method: .post,
                                           type: "getReleventSymptomsApiRequest"
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
    
    func onSuccess(data: Data, val: String) {
        loading = false
        switch val {
            
        case "getDiseasesApiRequest":
            do {
                
                let diseasesList = try JSONDecoder().decode(GetDiseasesResponse.self, from: data)
                
                for mydis in diseaseIDsList {
                    for dis in diseasesList.data {
                        if mydis == dis.id {
                            finalDiseases.append(dis)
                            orderDiseases.append((dis.name!))
                        }
                    }
                }
                self.ruler = Rules.defaultRule
                if yesSymptoms.count <= 3 {
                    isSymptomsExpended.toggle()
                }
                ifDiseaseFound = true
                
            } catch {
                print(error.localizedDescription)
                self.alertItem = AlertContext.errorMessage(message: error.localizedDescription)
            }
            break
            
        case "getReleventSymptomsApiRequest":
            do {
                let response = try JSONDecoder().decode(GetSymptomsByIDResponse.self, from: data)
                DispatchQueue.main.async { [self] in
                    
                    if response.data.count > 0 {
                        
                        for sym in response.data {
                            for i in sym {
                                totalSymptoms += 1
                                print(totalSymptoms)
                                symptomsList.append(i)
//                                print("\n\n\(symptomsList[0])")
                            }
                        }
                        
                        // seting values for first time
                        perSymptomProgress = maxProgress/totalSymptoms-1 // deviceWidth/totalSymptoms cz will array start's from 0
                        withAnimation { currentProgress = perSymptomProgress }
                        
                        self.ifReleventSymptomsFound = true
                    }
                }
            } catch {
                print(error.localizedDescription)
                self.alertItem = AlertContext.errorMessage(message: error.localizedDescription)
            }
            break
            
        default:
            break
        }
    }
    
    func onFailure(message: String) {
        loading = false
        print("OnFailure" + message)
        self.ruler = Rules.defaultRule
        self.alertItem = AlertContext.errorMessage(message: message)
    }
    
}

struct UserDefaultKeys {
    
    static let UserID     =  "UID"
    static let assesNo    =  "assesNo"
    static let symptoms   =  "symptoms"
    static let diseases   =  "diseases"
    static let date       =  "date"
    static let time       =  "time"
    
}

