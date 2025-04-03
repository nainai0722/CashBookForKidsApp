//
//  SettingView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI

struct SettingView: View {
    var settingList: [String] = ["タイトル","したく","スタンプ"]
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .padding()
            List {
                ForEach(settingList,id: \.self) { setting in
                    NavigationLink(destination: {
                        if setting == "タイトル" {
                            RoutineTitleListView()
                                .modelContainer(for: RoutineTitle.self)
                        }
                        if setting == "したく" {
                            RoutineListView()
                                .modelContainer(for: RoutineTitle.self)
                        }
                        if setting == "スタンプ" {
                            
                        }
                    }, label: {
                        Text(setting)
                    })
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
