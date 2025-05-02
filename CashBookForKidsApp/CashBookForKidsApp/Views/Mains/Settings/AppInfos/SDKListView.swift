//
//  SDKListView.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/19.
//

import SwiftUI

struct SDKListView: View {
    @StateObject var viewModel = SDKViewModel()
    let title: String = "SDK一覧"
    var body: some View {
        NavigationView {
            List(viewModel.sdkList) { sdk in
                VStack(alignment: .leading, spacing: 5) {
                    Text(sdk.identity).font(.headline)
                    Text("Version: \(sdk.state.version)").font(.subheadline)
                    Text("Revision: \(sdk.state.revision)").font(.caption)
                    Text(sdk.location).font(.caption2).foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle(title)
        }
        .onAppear {
            viewModel.loadJSON()
        }
    }
}
