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
        MainTitle(name: "app_info".localized, details:
                    [DetailTitle(name: "sdk_list".localized, view: AnyView(SDKListView())),
                     DetailTitle(name: "help_center".localized, view: AnyView(
                    InquiryView()
                  )),
                     DetailTitle(name: "other_app".localized, view: AnyView(OtherAppsView())),
                     DetailTitle(name: "privacy_policy".localized, view: AnyView(PrivacyView()))
                 ]),
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
        .navigationTitle("change_user_info".localized)
    }
}

#Preview {
    AppInfoView(title:"")
}

struct HogeView:View {
    @AppStorage("colorSchemeMode") private var colorSchemeMode: String = "system" // "light" / "dark" / "system"
    var body: some View {
        List {
            Text("no_goal_setting".localized)
                .onTapGesture {
                    colorSchemeMode = "system"
                }
            Text("dark_mode".localized)
                .onTapGesture {
                    colorSchemeMode = "dark"
                }
            Text("light".localized)
                .onTapGesture {
                    colorSchemeMode = "light"
                }
        }
    }
}
