//
//  KindarGardenCalendarView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/17.
//

import SwiftUI
import SwiftData

#Preview {
    KindergartenCalendarView()
        .modelContainer(for: TodayData.self)
}

struct KindergartenCalendarView: View {
    @Query private var todayDatas: [TodayData]
    var body: some View {
        VStack {
            BubbleView(text: "幼稚園に行ったら、スタンプを押そう")
                .padding()
            CustomCalendarViewView()
            
            Spacer()
        }
    }
}


struct CustomCalendarViewView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routineTitles: [RoutineTitle]
    @State private var selectedDates: Set<DateComponents> = []
    let weekLabel:[String] = ["月","火","水","木","金","土","日"]
    var body: some View {
        VStack {
            let calendar = Calendar(identifier: .gregorian)
            let today = Date()
            let days = getMonthDays(for: today, calendar: calendar)

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
                
                ForEach(weekLabel, id: \.self) { week in
                                    Text(week)
                                        .font(.headline)
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(.white)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                
                ForEach(days, id: \.self) { day in
                    VStack {
                        if let dayNumber = day.day{
                            Text("\(dayNumber)")
                                .font(.headline)
                                .frame(width: 40, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                                .onTapGesture {
                                    toggleDateSelection(day)
                                    updateSelectedDates(day)
                                }
                            if selectedDates.contains(where: { isSameDate($0, day) }) {
                                DoneTypeMonthlyStampView()
                            } else {
                                MonthlyNoStampView()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // 選択状態をトグルする
    private func toggleDateSelection(_ date: DateComponents) {
        if let existingDate = selectedDates.first(where: { isSameDate($0, date) }) {
            selectedDates.remove(existingDate)
        } else {
            selectedDates.insert(date)
        }
    }
    
    private func updateSelectedDates(_ date: DateComponents) {
        // TodayDataモデルから同じ日付のデータがないか調べる
        let selectedTodayData = fetchSelectedData(date)
        // 存在していれば、TodayDataのkindergartenCalendarGoneを更新する
        selectedTodayData.kindergartenCalendarGone = !selectedTodayData.kindergartenCalendarGone
        // modelContextを更新する
        try? modelContext.save()
    }

    private func fetchSelectedData(_ dateComponents: DateComponents) -> TodayData {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        
        guard let date = dateComponentsToDate(dateComponents) else {
            fatalError("無効な DateComponents: \(dateComponents)")
        }
        
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            let selectedDay = Calendar.current.startOfDay(for: date) // 0:00 のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: selectedDay) }) {
                return todayData
            }
        } catch {
            print("データの取得に失敗: \(error.localizedDescription)")
        }

        print("選択した日付のデータを新規作成")
        let newData = TodayData(timestamp: date, routineTitles: routineTitles)
        modelContext.insert(newData)
        return newData
    }

    // DateComponents → Date へ変換する関数
    private func dateComponentsToDate(_ dateComponents: DateComponents) -> Date? {
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }

    
    // 現在の月の日付を取得（正しい月曜始まり）
    private func getMonthDays(for date: Date, calendar: Calendar) -> [DateComponents] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstDay) // 1:日曜, 2:月曜, ..., 7:土曜
        let offset = (firstWeekday + 5) % 7  // 月曜始まりにするためのオフセット

        var days: [DateComponents] = []

        // 空白セルを埋める
        for _ in 0..<offset {
            days.append(DateComponents())
        }

        // 月の日付を追加
        for day in monthRange {
            var components = calendar.dateComponents([.year, .month], from: date)
            components.day = day
            days.append(components)
        }

        return days
    }

    // DateComponents の比較（年月日だけを見る）
    private func isSameDate(_ lhs: DateComponents, _ rhs: DateComponents) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
}


struct DoneTypeMonthlyStampView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.85))
                .frame(width: 40, height: 40) // サイズを指定
            Text("OK")
                .foregroundStyle(.white)
                .rotationEffect(.degrees(-45))
                .font(.system(size: 13))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
        }
        .frame(width: 50, height: 60)
    }
}

struct MonthlyNoStampView: View {
    var body: some View {
        ZStack {
            Text("  ")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
        }
        .frame(width: 50, height: 60)
    }
}
