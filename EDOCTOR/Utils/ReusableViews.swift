//
//  ReusableViews.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/7/22.
//

import SwiftUI

struct ReusableTextField: View {
    
    var tile                     = "Text Field Title"
    var placeholder              = "Placeholder"
    @Binding var fieldldFor:        String
    var fieldType: String        =  ""
    var thisCornersRadius: CGFloat = 10.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5)  {
            Text(tile)
                .bold()
                .padding(.leading, 5)
            
            if fieldType.elementsEqual("password") {
                SecureField("", text: $fieldldFor)
                    .placeholder(when: fieldldFor.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.black).opacity(0.4)
                    }
                    .accentColor(.black)
                    .foregroundColor(.black)
                    .frame(height: 25)
                    .padding()
                    .background(appColor2)
                    .cornerRadius(10)
            } else {
                TextField("", text: $fieldldFor)
                    .placeholder(when: fieldldFor.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.black).opacity(0.4)
                    }
                    .accentColor(.black)
                    .foregroundColor(.black)
                    .frame(height: 25)
                    .padding()
                    .background(appColor2)
                    .cornerRadius(thisCornersRadius)
            }
            
        }
        .padding(.horizontal).padding(.vertical, 12)
    }
}


struct ReusableTextEditor: View {
    
    var title                    = "Editor Title"
    var placeholder              = "Placeholder"
    var editorHeight: CGFloat    = 100
    @Binding var editorFor:      String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5)  {
            Text(title)
                .bold()
                .padding(.leading, 5)
            
            TextEditor(text: $editorFor)
                .placeholder(when: editorFor.isEmpty) {
                    VStack {
                        Text(placeholder)
                            .foregroundColor(.black).opacity(0.4)
                            .padding(.top, 8).padding(.leading, 4)
                        Spacer()
                    }
                }
                .frame(height: editorHeight, alignment: .topLeading)
                .padding(.vertical).padding(.horizontal)
                .accentColor(.black)
                .background(appColor2)
                .cornerRadius(10)
        }
        .padding(.horizontal).padding(.vertical, 12)
    }
}


struct ReusableButton: View {
    
    var title = "Button Title"
    var bgColor: Color = navigationColor
    var font: Font = .body
    var maxHeigh: CGFloat = 60.0
    var maxWidth: CGFloat = deviceWidth
    var forGround: Color = .white
    
    var body: some View {
        Text(title)
            .bold()
            .font(font)
            .foregroundColor(forGround)
            .padding()
            .frame(maxWidth: maxWidth, maxHeight: maxHeigh)
            .background(bgColor)
            .cornerRadius(100)
            .padding()
    }
}


struct ReusableBlankView: View {
    
    var height: CGFloat = 25
    var body: some View {
        Text("")
            .frame(maxWidth: .infinity, maxHeight: height)
            .padding(.vertical).padding(.horizontal)
            .accentColor(.black)
            .background(appColor2)
            .cornerRadius(10)
    }
}

