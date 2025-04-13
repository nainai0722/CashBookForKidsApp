//
//  MultiUserTabView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import SwiftUI
import RealmSwift

struct MultiUserTabView: View {
    @State var isShowFullScreen: Bool = false
    @ObservedResults(User.self) var users

    var body: some View {
        VStack {
            TabView {
                ForEach(users) { user in
                    UserMoneyListView(user: user)
                        .tabItem {
                            Text(user.name)
                        }
                }
                SettingView()
                    .tabItem {
                        Text("設定")
                    }
            }
            .fullScreenCover(isPresented: $isShowFullScreen) {
                RealmControl()
            }
        }
        .onAppear {
            isShowFullScreen = users.isEmpty ? true : false
        }
    }
}


#Preview {
    MultiUserTabView()
}
