//
//  CashBookForKidsAppApp.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/03.
//

import SwiftUI
import RealmSwift

@main
struct CashBookForKidsAppApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {

//            RealmControl()
            MultiUserTabView()
                .onAppear(){
                    
                }
        }
    }
}
