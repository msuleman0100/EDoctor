//
//  AuthVM.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/7/21.
//

import Foundation
import Firebase
import FirebaseAuth
import AVFoundation // for playing sound of Updating profile Enable/Disable...
import SwiftUI

class AuthVM: UIViewController, ObservableObject {
    
    //SignUp variables....
    @Published var UID = ""
    @Published var fullName = ""
    @Published var fName: String = ""
    @Published var lName: String = ""
    @Published var email: String = ""
    @Published var gender: String = ""
    @Published var dateOfBirth = ""
    @Published var genderStatus = true // this is selected gender, true for male false for female....
    @Published var password: String = ""
    
    // required...
    @Published var alertItem : AlertItem?
    @Published var loading = false
    @Published var waitingMessage = "One moment..."
    
    // navigation toggles...
    @Published var signupToggle: Bool = false
    @Published var homeToggle  = false
    @Published var isProfileUpdatingToDatabase = false
    @Published var feedbackSentToggle = false
    @Published var forgotPasswordToggle = false
    @Published var showDatePicker       = false
    
    // if updating profile
    @Published var isUpdatingEnabled = false
    @Published var updateProfileIcon = "lock.fill"
    
    // firebase database reference....
    var ref: DatabaseReference!
    @Published var ruler = Rules.defaultRule // this set the rules for different acitons....
    
    
    @Published var userProfileFound = false
    
    
    // reset password....
    func resetPassword() {
        if email.isEmpty {
            alertItem = AlertContext.errorMessage(message: "Please provide a valid email address.")
            return
        } else {
            loading = true
            Auth.auth().sendPasswordReset(withEmail: email) { [self] error in
                if error != nil {
                    loading = false
                    alertItem = AlertContext.errorMessage(message: error!.localizedDescription)
                    return
                } else {
                    loading = false
                    ruler = Rules.passwordResetted
                    alertItem = AlertContext.successMessage(title: "Lint Sent!",
                                                            message: "Instructions successfully sent to your email address for resetting your password.")
                }
            }
        }
    }
    
    
    // sendFeedback to firebase....
    func sendFeedback(feedback: String) {
        if feedback.isEmpty {
            return
            
        } else {
            loading = true
                ref = Database.database().reference()
                let userID : String = (Auth.auth().currentUser?.uid)!
                
                let dateNow = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss aaa"
                let currentDate = dateFormatter.string(from: dateNow)
                
                ref.child("Feedbacks").child(userID).child(currentDate).updateChildValues(["email": self.email])
                ref.child("Feedbacks").child(userID).child(currentDate).updateChildValues(["feedback": feedback])
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            withAnimation {
                loading = false
                feedbackSentToggle.toggle()
            }
        }
    }
    
    //SignUp function.......
    func Signup() {
        ref = Database.database().reference()
        
        if fName.isEmpty || lName.isEmpty || email.isEmpty ||
            gender.isEmpty || dateOfBirth.description.isEmpty || password.isEmpty {
            self.alertItem = AlertContext.errorMessage(message: "Invalid user informations")
            return
            
        }
        loading = true
        Auth.auth().createUser(withEmail: self.email, password: self.password) { [self] (result, error) in
            if let _ = error {
                loading = false
                self.alertItem = AlertContext.errorMessage(message: error!.localizedDescription)
                
            }else{
                
                // saving into firebase....
                let uid = (Auth.auth().currentUser?.uid)!
//                self.UID = uid // this UID will need to identify the UserAssessment later
                ref.child("Users").child(uid).setValue([
                    "firstName": self.fName,
                    "lastName": self.lName,
                    "email": self.email,
                    "gender": self.gender,
                    "dateOfBirth": dateOfBirth
                ])
                loading = false
                self.ruler = Rules.registerSuccess
                self.alertItem = AlertContext.errorMessage(title: "Registered!",
                                                           message: "You have successfully registered, please login to your account to contninue.")
                
            }
        }
    }
    
    // Login function.....
    func Login() {
        loading = true
        Auth.auth().signIn(withEmail: self.email, password: self.password) { [self] (result, error) in
            if error != nil {
                loading = false
                self.alertItem = AlertContext.errorMessage(message: error!.localizedDescription)
                return
            } else {
//                let uid = (Auth.auth().currentUser?.uid)!
//                self.UID = uid // this UID will need to identify the UserAssessment later
                loading = false
                homeToggle.toggle()
            }
        }
    }
    
    // get user-profile...
    func getUserProfile() {
        loading = true
        ref = Database.database().reference()
        let userID : String = (Auth.auth().currentUser?.uid)!
        ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { [self] (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            fName = value?["firstName"] as? String ?? "default"
            lName = value?["lastName"] as? String ?? "default"
            email = value?["email"] as? String ?? "default"
            gender = value?["gender"] as? String ?? "default"
            dateOfBirth = value?["dateOfBirth"] as? String ?? "default"
            fullName = fName + " " + lName
            
            userProfileFound = true
            loading = false
            
        }) { (error) in
            self.loading = false
            self.alertItem = AlertContext.errorMessage(message: error.localizedDescription)
        }
    }
    
    func updateUserProfile(gender: String) {
        loading = true
        
        ref = Database.database().reference()
        let userID : String = (Auth.auth().currentUser?.uid)!
        
        ref.child("Users").child(userID).updateChildValues(["firstName": self.fName])
        ref.child("Users").child(userID).updateChildValues(["lastName": self.lName])
        ref.child("Users").child(userID).updateChildValues(["gender": gender])
        ref.child("Users").child(userID).updateChildValues(["dateOfBirth": dateOfBirth])
        getUserProfile()
        
        isUpdatingEnabled.toggle()
        updateProfileIcon = "lock.fill"
        AudioServicesPlaySystemSound(1003)
    }
    
    
}
