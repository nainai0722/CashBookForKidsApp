//
//  SampleChart.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/09.
//

import SwiftUI

struct SampleChart: View {
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        PieChartView()
    }
}

#Preview {
    SampleChart()
}

import SwiftUI
import Charts

struct PieChartData: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}

struct PieChartView: View {
    let data: [PieChartData] = [
        PieChartData(category: "A", value: 40),
        PieChartData(category: "B", value: 30),
        PieChartData(category: "C", value: 20),
        PieChartData(category: "D", value: 10)
    ]

    var body: some View {
        Chart(data) { element in
            SectorMark(
                angle: .value("Value", element.value),
                innerRadius: .ratio(0.5),
                outerRadius: .ratio(1.0)
            )
            .foregroundStyle(by: .value("Category", element.category))
        }
        .frame(width: 200, height: 200)
    }
}

