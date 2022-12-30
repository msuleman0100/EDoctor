//
//  NetworkAlert.swift
//
//
//  Created by EAPPLE on 31/07/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidURL = AlertItem(title: Text("Server Error"), message: Text("The Data Received from the Server is invalid. Please contact support"), dismissButton: .default(Text("Ok")))
    
    static let invalidResponse = AlertItem(title: Text("Server Error"), message: Text("Invalid response from the server. Please try again later or contact support"), dismissButton: .default(Text("Ok")))
    
    static let invalidData = AlertItem(title: Text("Server Error"), message: Text("There was an issue connecting to the server if this persisits, please contact support"), dismissButton: .default(Text("Ok")))
    
    static let unableToComplete = AlertItem(title: Text("Server Error"), message: Text("Unable to complete your request at this time. Please check your internet connection"), dismissButton: .default(Text("Ok")))
    
//    static let errorMessage = AlertItem(title: Text("Failed"), message: Text("Unable to complete your request at this time. Please check your internet connection"), dismissButton: .default(Text("Ok")))
    
    static func errorMessage(title: String = "Failed", message: String) -> AlertItem {
        return AlertItem(title: Text(title), message: Text(message), dismissButton: .default(Text("Ok")))
    }
    
    static func successMessage(title: String, message: String) -> AlertItem {
        return AlertItem(title: Text(title), message: Text(message), dismissButton: .default(Text("Ok")))
    }
    
}


