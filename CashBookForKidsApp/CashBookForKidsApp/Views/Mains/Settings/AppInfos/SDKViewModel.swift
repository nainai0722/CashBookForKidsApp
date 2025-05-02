//
//  SDKViewModel.swift
//  YourRoutineApp
//
//  Created by 指原奈々 on 2025/04/19.
//

import Foundation

class SDKViewModel: ObservableObject {
    @Published var sdkList: [SDKData] = []

    func loadJSON() {
        guard let url = Bundle.main.url(forResource: "Package", withExtension: "resolved") else {
            print("ファイルが見つかりません")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(SDKResolved.self, from: data)
            DispatchQueue.main.async {
                self.sdkList = decoded.pins
            }
        } catch {
            print("デコードエラー: \(error)")
        }
    }
}
