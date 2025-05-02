//
//  PrivacyView.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/20.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        WebViewScreen(urlString: "https://nainai0722.github.io/privacy-policy-quizApp/privacy_en")
    }
}

#Preview {
    PrivacyView()
}
import SwiftUI
import WebKit

// 1. WebViewラッパー
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// 2. 実際に使うビュー
struct WebViewScreen: View {
    var urlString: String

    var body: some View {
        if let url = URL(string: urlString) {
            WebView(url: url)
                .edgesIgnoringSafeArea(.all)
        } else {
            Text("URLが無効です")
        }
    }
}

// 3. プレビュー
struct WebViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        WebViewScreen(urlString: "https://example.com")
    }
}

