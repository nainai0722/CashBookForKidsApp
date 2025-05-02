//
//  OtherAppsView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/05/01.
//

import SwiftUI

struct OtherAppsView: View {
    let apps: [OtherApp] = [
        OtherApp(
            title: "作れる遊べるクイズアプリ",
            description: "自分でクイズを作って、遊べる！小学生向けの学習アプリ。",
            imageName: "quizAppIcon", // Assets.xcassets に登録
            urlString: "https://apps.apple.com/jp/app/%E4%BD%9C%E3%82%8C%E3%82%8B%E9%81%8A%E3%81%B9%E3%82%8B%E3%82%AF%E3%82%A4%E3%82%BA/id6744341981"
        ),
        OtherApp(
            title: "おしたくしよう",
            description: "毎朝のおしたくを楽しくサポート。お子さまの習慣づけに！",
            imageName: "oshitakuIcon", // Assets.xcassets に登録
            urlString: "https://apps.apple.com/jp/app/%E3%81%8A%E3%81%97%E3%81%9F%E3%81%8F%E3%81%97%E3%82%88%E3%81%86/id6744842263"
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("この開発者の他のアプリ")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                ForEach(apps, id: \.urlString) { app in
                    AppCardView(app: app)
                }
            }
            .padding()
        }
    }
}

struct AppCardView: View {
    let app: OtherApp

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(app.imageName)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    Text(app.title)
                        .font(.headline)
                    Text(app.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Link("App Storeで見る", destination: URL(string: app.urlString)!)
                .font(.callout)
                .foregroundColor(.blue)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct OtherApp {
    let title: String
    let description: String
    let imageName: String
    let urlString: String
}


#Preview {
    OtherAppsView()
}
