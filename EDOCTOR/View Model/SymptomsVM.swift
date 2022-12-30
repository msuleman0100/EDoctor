//
//  SymptomsVM.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/12/21.
//

import Foundation
import SwiftUI
import Alamofire

final class SymptomsVM: UIViewController, ObservableObject, serverResponseData  {
    
    // MARK: Properties
    
    @Published var getSymptoms: GetSymptomsResponse? = nil
    
    // required....
    @Published var alertItem : AlertItem?
    @Published var loading = false
    
    @Published var apiResponseMessage = "Retrieving symptoms..."
    
    @Published var watingMessage = "One moment..." // somthing in message while loading
    
//    @Published var ifSymptomsFound = false
    @Published var selectedSymptomID = -1
    @Published var QAViewToggle = false
    
    func getSymptomsApiRequest() {
        loading = true
        
        let params: [String: Any] = [:]
        
        serverRequest.dataDelegate = self
        
        serverRequest.requestAndReturnData(url: API.getSymptoms,
                                           params: params,
                                           method: .get,
                                           type: "getSymptomsApiRequest"
        )
    }
    
    func onSuccess(data: Data, val: String) {
        loading = false
        switch val {
            
        case "getSymptomsApiRequest":
                do {
                    self.getSymptoms = try JSONDecoder().decode(GetSymptomsResponse.self, from: data)
                    DispatchQueue.main.async {
                        withAnimation { self.apiResponseMessage = "" }
                    }
                } catch {
                    self.apiResponseMessage = "Unable to loaded Symptoms because\(error.localizedDescription)"
                }
            break
            
        default:
            break
        }
    }
    
    func onFailure(message: String) {
        loading = false
        print("OnFailure" + message)
        self.apiResponseMessage = "Symptoms couldn't loaded\n \(message) " // If symptoms didn't loaded...
        self.alertItem = AlertContext.errorMessage(message: message)
    }
}
