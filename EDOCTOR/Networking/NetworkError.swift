//
//  NetworkError.swift
//  MVVM_Networking
//
//  Created by EAPPLE on 31/07/2021.
//

import Foundation

enum NetworkError : Error{
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case errorMessage(errorMessage: String)
}
