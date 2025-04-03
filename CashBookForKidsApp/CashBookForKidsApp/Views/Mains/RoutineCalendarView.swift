//
//  RoutineCalendarView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/12.
//

import SwiftUI
import SwiftData

#Preview {
    
    RoutineCalendarView()
        .modelContainer(for: TodayData.self)
    
}

struct RoutineCalendarView:View {
    @Query private var todayDatas: [TodayData]
    @State var selectedTodayData: TodayData?
    @State private var showDetail = false
    @Query private var routineTitles: [RoutineTitle]
    var completeTodayDatas: [TodayData] {
        fillMissingDates(todayDatas: todayDatas)
    }
    var body: some View {
        VStack {
            Text("一週間のおしたく表")
                .font(.title)
                .bold()
                .padding()
                .padding(.top,30)
            
            ScrollView(Axis.Set.horizontal) {
                HStack (spacing: 2) {
                    ForEach(completeTodayDatas, id: \.self) { todayData in
                        TodayDataCellView(todayData: todayData,selectedTodayData: $selectedTodayData)
                    }
                }
            }
            
            
            if let selectedTodayData = selectedTodayData {
                ScrollView {
                    TodayDataDetailView(selectedTodayData: Binding(
                        get: { selectedTodayData },
                        set: { self.selectedTodayData = $0 }
                    ))
                }
            }
            
            Spacer()
            
        }
    }
    
    func dayCount() -> Int {
        todayDatas.count
    }
    
    func firstDay(_ index: Int) -> TodayData? {
        todayDatas.first
    }
    
    func lastDay(_ index: Int) -> TodayData? {
        todayDatas.last
    }
    
    func fillMissingDates(todayDatas: [TodayData]) -> [TodayData] {
        guard !todayDatas.isEmpty else { return [] }

            let sortedData = todayDatas.sorted(by: { $0.timestamp < $1.timestamp }) // 昇順ソート
        
        guard let first = sortedData.first, let last = sortedData.last else { return [] }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: first.timestamp)
        let endDate = calendar.startOfDay(for: last.timestamp)
        
        var filledData: [TodayData] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            if let existingData = todayDatas.first(where: { calendar.isDate($0.timestamp, inSameDayAs: currentDate) }) {
                // 既存データがある場合はそのまま使う
                filledData.append(existingData)
            } else {
                // ない場合は新規作成
                let newData = TodayData(timestamp: currentDate, routineTitles: routineTitles)
                filledData.append(newData)
            }
            
            // 次の日に進める
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return filledData
    }
}

struct TodayDataCellView:View {
    var todayData:TodayData = TodayData()
    @Binding var selectedTodayData: TodayData?
    var body: some View {
        Button(action:{
            selectedTodayData = todayData
            print("\(selectedTodayData?.timestamp)")
        }){
            VStack (spacing: 2){
                VStack(spacing:0) {
                    Text(todayData.timestamp.formattedMonthDayString)
                    Text(todayData.timestamp.weekString)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                
                if todayData.morningRoutineDone {
                    DoneTypeWeeklyStampView()
                } else {
                    EmptyCellView()
                }
                if todayData.eveningRoutineDone {
                    DoneTypeWeeklyStampView()
                } else {
                    EmptyCellView()
                }
                
            }
        }
    }
    
    func week() -> String {
        todayData.timestamp.weekString
    }
}

struct DoneTypeWeeklyStampView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.85))
                .frame(width: 40, height: 40) // サイズを指定
            Text("OK")
                .foregroundStyle(.white)
                .rotationEffect(.degrees(-45))
                .font(.system(size: 15))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
        }
    }
}

struct EmptyCellView: View {
    var body: some View {
        Text("           ")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
    }
}

