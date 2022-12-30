//
//  IMTestingvIEW.swift
//  Piranha-App
//
//  Created by Muhammad Salman on 1/3/22.
//

import SwiftUI

struct DatePickerView: View {
    
    
    @Binding var selectedDate: String
    var message = "Choose your desired date."
    var dateFormate = "dd-MM-yyyy" // hold a string with date-formate/modifiable
    @State var date = Date()
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(spacing: 30) {
            
            HStack {
                Spacer()
                Text("**Date Picker**")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.leading, 60)
                
                Spacer()
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .onTapGesture {
                        mode.wrappedValue.dismiss()
                    }
            }
            .padding()
            .background(navigationColor)
            
            Spacer()
            
            Text(message)
                .font(.title2)
            
            VStack {
                DatePicker(
                    "This shouldn't appear as a label",
                    selection: $date,
                    displayedComponents: .date)
                    .accentColor(navigationColor)
                    .border(navigationColor)
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(0)
                    .border(navigationColor)
            }
            
            Button {
                let formatter1 = DateFormatter()
                formatter1.dateFormat = dateFormate
//                print(formatter1.string(from: date))
                selectedDate = formatter1.string(from: date)
                mode.wrappedValue.dismiss()
            } label: {
                ReusableButton(title: "Save")
                    .padding()
                    .padding(.horizontal, 50)
            }

            Spacer()
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(selectedDate: .constant(""))
    }
}
