//
//  InquiryView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/05/02.
//


import SwiftUI
import MessageUI
import UIKit

struct InquiryView: View {
    @State private var inquiryType = "アプリの改善"
    @State private var inquiryDetail = ""
    @State private var includeDeviceInfo = false
    @State private var isShowingMailView = false
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isSendPopup: Bool = false
    let inquiryOptions = ["アプリの改善", "不具合連絡", "意見や感想"]

    var body: some View {
        
        Form {
            Section(header: Text("問い合わせ種別")) {
                Picker("種類を選択", selection: $inquiryType) {
                    ForEach(inquiryOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("詳細")) {
                TextEditor(text: $inquiryDetail)
                    .frame(height: 150)
            }

            Section {
                Toggle("端末情報を含める", isOn: $includeDeviceInfo)
            }
            
            Button("メール送信") {
                isShowingMailView = true
                inquiryDetail = ""
                isSendPopup = true
            }
            .disabled(!MFMailComposeViewController.canSendMail())
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(
                subject: inquiryType,
                body: generateBody(),
                result: $result
            )
        }
        
    }

    func generateBody() -> String {
        var body = inquiryDetail
        
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        body += "\n\nアプリ名: \(appName ?? "不明")"

        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String

        body += "\n\nアプリ名: \(appName ?? "不明")\nアプリバージョン: \(appVersion ?? "不明")\nビルドバージョン: \(appBuild ?? "不明")"
        
        if includeDeviceInfo {
            let device = UIDevice.current
            body += """

            \n\n--- 端末情報 ---
            機種: \(device.model)
            システム: \(device.systemName) \(device.systemVersion)
            """
        }
        return body
    }
}


#Preview {
    InquiryView()
}
