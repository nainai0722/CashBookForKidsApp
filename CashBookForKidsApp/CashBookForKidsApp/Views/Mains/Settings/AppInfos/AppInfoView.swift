//
//  AppInfoVIew.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/19.
//

import SwiftUI


struct AppInfoView: View {
    struct DetailTitle: Identifiable {
        let name: String
        let view: AnyView
        let id = UUID()
    }
    
//    extension DetailTitle: Hashable {
//        static func == (lhs: DetailTitle, rhs: DetailTitle) -> Bool {
//            return lhs.id == rhs.id
//        }
//
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(id)
//        }
//    }

    struct MainTitle: Identifiable {
        let name: String
        let details: [DetailTitle]
        let id = UUID()
    }
    
    let settings: [MainTitle] = [
        MainTitle(name: "アプリ情報", details:
                 [DetailTitle(name: "SDK一覧", view: AnyView(SDKListView())),
                  DetailTitle(name: "お問い合わせ", view: AnyView(
                    InquiryView()
                  )),
                  DetailTitle(name: "その他アプリ", view: AnyView(OtherAppsView())),
                  DetailTitle(name: "プライバシーポリシー", view: AnyView(PrivacyView()))
                 ]),
        
//        MainTitle(name: "設定1", details: [DetailTitle(name: "ダーク・ライト切り替え", view: AnyView(HogeView())),DetailTitle(name: "アイコン変更", view: AnyView(SDKListView())), DetailTitle(name: "言語設定", view: AnyView(SDKListView()))])
    ]
    @State private var singleSelection: UUID?
    let title: String
    var body: some View {
        NavigationStack {
            List(selection: $singleSelection) {
                ForEach(settings) { setting in
                    Section(header: Text(setting.name)) {
                        ForEach(setting.details) { detail in
                            NavigationLink(destination: {
                                detail.view
                                    .navigationTitle(title)
                            }, label: {
                                Text(detail.name)
                            })
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    AppInfoView(title:"")
}

struct HogeView:View {
    @AppStorage("colorSchemeMode") private var colorSchemeMode: String = "system" // "light" / "dark" / "system"
    var body: some View {
        List {
            Text("特に設定しない")
                .onTapGesture {
                    colorSchemeMode = "system"
                }
            Text("ダーク")
                .onTapGesture {
                    colorSchemeMode = "dark"
                }
            Text("ライト")
                .onTapGesture {
                    colorSchemeMode = "light"
                }
        }
    }
}
