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
    @State private var inquiryType = "inquiry_improvement".localized
    @State private var inquiryDetail = ""
    @State private var includeDeviceInfo = false
    @State private var isShowingMailView = false
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isSendPopup: Bool = false
    
    let inquiryOptionKeys = [
        "inquiry_improvement",
        "inquiry_bug_report",
        "inquiry_feedback"
    ]
    
    var body: some View {
        
        Form {
            Section(header: Text("contact_type".localized)) {
                Picker("select_type".localized, selection: $inquiryType) {
                    ForEach(inquiryOptionKeys, id: \.self) { key in
                        Text(LocalizedStringKey(key))
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("details".localized)) {
                TextEditor(text: $inquiryDetail)
                    .frame(height: 150)
            }

            Section {
                Toggle("include_device_info".localized, isOn: $includeDeviceInfo)
            }
            
            Button("send_mail".localized) {
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
