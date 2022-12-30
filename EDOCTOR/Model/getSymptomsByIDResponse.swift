//
//  getSymptomsByIDResponse.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/12/21.
//

import Foundation

// MARK: - GetSymptomsByIDResponse
struct GetSymptomsByIDResponse: Codable, Hashable {
    let status: Int
    let message: String
    let data: [[GetSymptomsByIDResponseData]]
}

// MARK: - Datum
struct GetSymptomsByIDResponseData: Codable, Hashable {
    let id: Int
    let symptomID, symptomName, symptomDescription: String?
    let symptomQuestion: String?
    let diseaseID, diseaseName: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case symptomID = "symptom_id"
        case symptomName = "symptom_name"
        case symptomDescription = "symptom_description"
        case symptomQuestion = "symptom_question"
        case diseaseID = "disease_id"
        case diseaseName = "disease_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
