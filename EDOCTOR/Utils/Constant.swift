//
//  Constant.swift
//  Carrera
//
//  Created by Asim on 30/08/2021.
//

import SwiftUI
import Foundation
import UIKit
import SwiftfulLoadingIndicators // for custom loading view...


// COLOR

//let backgroundColor: Color = Color("appColor")
let appColor: Color          = Color("appColor")
let appColor2: Color         = Color("appColor2")
let navigationColor: Color   = Color("navigationColor")


let secondaryColor: Color = Color("secondaryColor")
let toolBarColor: Color = Color("appColor")
let stepsBoxesColor: Color = Color("secondaryColor")
let placeHolderColor: Color = Color("placeHolderColor")
let assessmentBoxColor: Color = Color("assessmentBoxColor")

let bigTitleColor: Color = Color("bigTitleColor")
let ScheuleViewBackgroundColor: Color = Color("ScheuleViewBackgroundColor")
let textFieldBackColor: Color = Color.white.opacity(0.6)

let sYellow: Color = Color("yellowSeverityColor")
let sGreen: Color = Color("greenSeverityColor")
let sRed: Color = Color("redSeverityColor")

// LAYOUT

let columnSpacing: CGFloat = 4
let rowSpacing: CGFloat = 4
let spacing: CGFloat = 8

// Device
let deviceWidth = UIScreen.main.bounds.width
let deviceHeight = UIScreen.main.bounds.height

//let cornerRadius: CGFloat = 10.0

var gridLayout: [GridItem] {
    return Array(repeating: GridItem(.flexible(), spacing: rowSpacing), count: 1)
}

let corner: CGFloat = 10.0
let btnCorder: CGFloat = 25.0
let toolBarPading: CGFloat = 25
let shadow: Int = 5

/// Loading View...............
struct LoadingView: View {
    var body: some View {
        VStack {
//            LoadingIndicator(animation: .heart, color: secondaryColor, size: .medium, speed: .normal)
            LoadingIndicator(animation: .text, color: navigationColor, size: .large, speed: .normal)
        }
    }
}

/// just paste this code at the final stack of a view....ge
/// .onTapGesture {
/// self.hideKeyboard()
/// }
//...........................................................................................


//  For hiding keyboard clicking outside of the textfields........................................
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//


/// Email Validation............
func textFieldValidatorEmail(_ string: String) -> Bool {
    if string.count > 100 {
        return false
    }
    let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: string)
}
//...........................................................................................

/// IMAGE SIZE REDUCING CODE............
extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }}
}

func compressImage(image: UIImage) -> UIImage {
    let resizedImage = image.aspectFittedToHeight(80)
    resizedImage.jpegData(compressionQuality: 0.2)
    return resizedImage
}
//...........................................................................................

/// Firebase Realtime database data insertion............
// import Firebase
// import FirebaseAuth

// Code.....
/*
 let uid = (Auth.auth().currentUser?.uid)!
 var ref: DatabaseReference!
 ref = Database.database().reference()
 ref.child("Users").child(uid).setValue(["name": name, "email": email, "password": password])
 */
//...........................................................................................


/// Firestore Database insertion..................
// import FirebaseFirestore
// private var db = Firestore.firestore()

// Code...
/*
 do {
 let uid = (Auth.auth().currentUser?.uid)!
 _ = try db.collection("Users").addDocument(data: ["uid": uid, "name": name, "email": email, "password": password])
 self.message.append("and Realtime database.")
 self.isLoading = false
 self.showingAlert.toggle()
 }
 catch {
 self.title = "Firestore Error!"
 self.message = error.localizedDescription
 self.isLoading = false
 self.showingAlert.toggle()
 }
 */
//...........................................................................................

/// API get data........................
/*
 func getData() {
 isLoading = true
 let request = URLRequest(url: URL(string: "https://run.mocky.io/v3/1ff96e69-10ae-4ca1-8f39-9ba1274f1b22/1")!)
 let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
 if error != nil {
 print(error!)
 isLoading = false
 return
 }
 if let response = response {
 print(response)
 isLoading = false
 }
 if let data = data {
 do
 {
 users = try JSONDecoder().decode([User].self, from: data)
 }
 catch {
 print("Could not decode the data. Error: \(error)")
 isLoading = false
 }
 }
 }
 task.resume()
 }
 */

//...........................................................................................

// Custom Rounded Corners..........
struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//step 2 - embed shape in viewModifier to help use with ease
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}


/// extend this code from the view that needs custom corners
/*
 
 extension View {
 func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
 ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
 }
 }
 
 */

/// And then use it as modifier on the particular view like this....
/*
 .cornerRadius(radius: 30.0, corners: [.bottomLeft, .bottomRight])
 */

//...........................................................................................

//


// Image Picker.....

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}



//Call this on button action....
//ImagePicker(sourceType: .photoLibrary, selectedImage: savedImage)

//...........................................................................................


// Image-To-Base64-Convertor.............
func convertImageToBase64(_ image: UIImage) -> String {
   
   
    let imageData:NSData = image.pngData()! as NSData

    // Image to Base64:
    let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
    
    return strBase64
}


//...........................................................................................

//// Date getting formate...............
//let date = Date()
//let format = DateFormatter()
//format.dateFormat = "MM"//"yyyy-MM-dd HH:mm:ss"
//let formattedDate = format.string(from: date)
//print(formattedDate)
////...........................................................................................


/// Custom toolBar.....................
class CustomToolBar {
    static func navigationBarColors(background : UIColor?,
       titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
//...........................................................................................





 // Pick image from gallary
 struct imagePicker: UIViewControllerRepresentable {

   @Environment(\.presentationMode)
   var presentationMode

   @Binding var image: UIImage?

   class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

     @Binding var presentationMode: PresentationMode
     @Binding var image: UIImage?

     init(presentationMode: Binding<PresentationMode>, image: Binding<UIImage?>) {
       _presentationMode = presentationMode
       _image = image
     }

     func imagePickerController(_ picker: UIImagePickerController,
                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       image = uiImage
       presentationMode.dismiss()

     }

     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       presentationMode.dismiss()
     }

   }

   func makeCoordinator() -> Coordinator {
     return Coordinator(presentationMode: presentationMode, image: $image)
   }

   func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
     let picker = UIImagePickerController()
     picker.delegate = context.coordinator
     return picker
   }

   func updateUIViewController(_
                   uiViewController:
                   UIImagePickerController,
                   context:
                   UIViewControllerRepresentableContext<imagePicker>) {

   }



 }


 // Convert image to base64
 func convertImgBase64 (img: UIImage) -> String {
   let image64Bit = img.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
   return image64Bit
  }


