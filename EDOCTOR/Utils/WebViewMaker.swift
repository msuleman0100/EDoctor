//
//  WebViewMaker.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 12/6/21.
//

import SwiftUI
import WebKit

// This create the view........
struct WebViewMaker: UIViewRepresentable {
    
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
