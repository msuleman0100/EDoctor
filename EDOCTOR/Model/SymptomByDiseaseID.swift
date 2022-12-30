//
//  SymptomByDiseaseID.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/4/22.
//

import Foundation
// MARK: - GetSymptomsByDiseaseIDResponse
struct GetSymptomsByDiseaseIDResponse: Codable, Hashable {
    let status: Int
    let message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable, Hashable {
    let id: Int
    let symptomID, symptomName, question, symptomDescription, diseaseID, diseaseName: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case symptomID = "symptom_id"
        case symptomName = "symptom_name"
        case question = "symptom_question"
        case symptomDescription = "symptom_description"
        case diseaseID = "disease_id"
        case diseaseName = "disease_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
