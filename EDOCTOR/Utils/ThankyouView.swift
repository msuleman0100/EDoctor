//
//  ThankYouView.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/18/21.
//

import SwiftUI

struct ThankyouView: View {
    
    @EnvironmentObject var qAVM: QAVM
    
    var body: some View {
            VStack(alignment: .leading, spacing: 30) {
                
                Spacer()
                
                Image("LOGO")
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Thank you, All done!")
                        .font(.title3)
                        .bold()
                    Text("I have put togather a report that outlines possible causes for your symptoms.")
                        .lineSpacing(7)
                }
                .padding(.leading)
                
                Text("Don't forget that this is not a medical dignosis. If in doubt it is always best to seek advice from a medical profissional.")
                    .lineSpacing(7)
                    .padding(.leading)
                
                Spacer()
                
                Button {
                    qAVM.ruler = Rules.reportsDone
                    qAVM.thankYouViewToggle.toggle()
                } label: {
                    ReusableButton(title: "Open report", font: .title2)
                        .padding(.horizontal)
                }
                
                Spacer()
                
            }
            .background(appColor)
            .padding()
    }
}


struct ThankyouView_Previews: PreviewProvider {
    static var previews: some View {
        ThankyouView()
    }
}
