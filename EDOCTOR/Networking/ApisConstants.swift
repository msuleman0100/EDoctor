//
//  ApisConstants.swift
//  StaffApp
//
//  Created by Admin Admin on 10/18/21.
//

import Foundation
// API
struct API {
    
    // Base URL...
    static let baseURL = "http://145.14.158.138/disease-prediction/public/index.php/api/"

    // End Points...
    static let getSymptoms             = "getSymptoms"
    static let getSymptomsByID         = "getSymptomsByID"
    static let getDiseases             = "getDiseases"
    static let createDiseases          = "createDiseases"
    static let createSymptoms          = "createSymptoms"
    static let getSymptomsByDiseaseID  = "getSymptomsByDiseaseID"
    static let updateDisease           = "updateDisease"
    static let updateSymptoms          = "updateSymptoms"
    static let deleteSymptoms          = "deleteSymptoms"
    static let deleteDisease           = "deleteDisease"
    
}
