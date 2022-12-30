//
//  WebsiteView.swift
//  EDOCTOR
//
//  Created by Maani on 11/1/21.
//

import SwiftUI

struct WebView: View {
    
    var url = "https://www.who.int"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            WebViewMaker(url: URL(string: url)!)
                .frame(maxWidth: deviceWidth, maxHeight: deviceHeight)
                .onOpenURL { url in
                    print("loaded now")
                }
                
            
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("LOGO")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// preview....
struct WebsiteView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
