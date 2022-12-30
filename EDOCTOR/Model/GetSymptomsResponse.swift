//
//  getDiseasesResponse.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/12/21.
//

import Foundation

import Foundation

// MARK: - GetDiseasesResponsee
struct GetSymptomsResponse: Codable, Hashable {
    let status: Int
    let message: String
    let data: [SymptomsData]
}

// MARK: - Datum
struct SymptomsData: Codable, Hashable {
    let id: Int
    let name: String
    let datumDescription, keyFact: String?
    let doctorLink: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case datumDescription = "description"
        case keyFact = "key_Fact"
        case doctorLink = "doctor_link"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
