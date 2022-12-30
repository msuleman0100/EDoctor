//
//  getDiseaseResponse.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/16/21.
//

import Foundation

// MARK: - GetDiseasesResponse
struct GetDiseasesResponse: Codable, Hashable {
    let status: Int?
    let message: String?
    let data: [DiseasesData]
}

// MARK: - DiseasesData
struct DiseasesData: Codable, Hashable {
    let id: Int
    let name: String?
    let datumDescription, keyFact: String?
    let doctorLink: String?
    let refrenceLink, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case datumDescription = "description"
        case keyFact = "key_Fact"
        case doctorLink = "doctor_link"
        case refrenceLink = "refrence_link"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
