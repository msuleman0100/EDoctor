//
//  MoveToNextView.swift
//  EDOCTOR
//
//  Created by Maani on 10/24/21.
//

import SwiftUI

struct FabButtonView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(secondaryColor)
                        .frame(width: 60, height: 60)
                        .cornerRadius(radius: 30.0, corners: [.topLeft])
                    Image(systemName: "arrow.forward")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
        }
    }
}

struct MoveToNextView_Previews: PreviewProvider {
    static var previews: some View {
        FabButtonView()
    }
}
