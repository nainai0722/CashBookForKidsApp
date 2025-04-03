//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/11.
//

import SwiftUI
import SwiftData

let calendar = Calendar(identifier: .gregorian)
let date20250301 = calendar.date(from: DateComponents(year: 2025, month: 3, day: 1))

struct DoneRoutineView: View {
    @Binding var selectedTab: Int  // MainTabView から渡す
    @Environment(\.modelContext) private var modelContext
    @Query private var todayDatas: [TodayData]
    @Query private var routineTitles: [RoutineTitle]
    @State var todayData:TodayData = TodayData()
    @State var routineName: String = ""
    @State var routines :[Routine] = []
    var body: some View {
        NavigationSplitView {
            ZStack {
                VStack {
                    Text(routineName)
                        .font(.title)
                    Menu("したくをえらぶ") {
                        ForEach(todayData.routineTitles,id:\.id) { routineTitle in
                            Button(routineTitle.name, action: {
                                routines = routineTitle.routines
                                routineName = routineTitle.name
                            })
                        }
                    }
                    .menuStyle(ButtonMenuStyle())
                    
                    BubbleView(text:"できたらスタンプを押してね！" )
                    
                    RoutineStampView(routines: $routines)
                    
                    Spacer()
                    
                    if allDoneCheck() {
                        NavigationLink {
                            RoutineCalendarView()
                        } label: {
                            Text("カレンダーを見る")
                                .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .red, fontType: .title))
                        }
                    }
                }
                if allDoneCheck() {
                    AllDone_StampView()
                        .onAppear(){
                            updateRoutinesDone()
                        }
                }
            }
        } detail: {
            Text("Select an money")
        }
        .onAppear(){
            fetchRoutineTitle()
            fetchTodayData()
        }
        
    }
    
    private func fetchRoutineTitle() {
        if routineTitles.isEmpty {
            addDefaultsRoutineTitle()
        }
    }

    private func addDefaultsRoutineTitle() {
        let newRoutineTitle1 = RoutineTitle(name: "あさのしたく", routines: Routine.mockMorningRoutines)
        let newRoutineTitle2 = RoutineTitle(name: "ゆうがたのしたく", routines: Routine.mockEveningRoutines)
        let newRoutineTitle3 = RoutineTitle(name: "ねるまえのしたく", routines: Routine.mockSleepTimeRoutines)
        do {
            try modelContext.insert(newRoutineTitle1)
            try modelContext.insert(newRoutineTitle2)
            try modelContext.insert(newRoutineTitle3)
            try modelContext.save()
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
    private func fetchTodayData() {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        if let allDays = try? modelContext.fetch(fetchDescriptor) {
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                self.todayData = todayData
                print("今日のデータ: \(todayData.timestamp.formatted())")
                print("routineTitles一覧")
                for title in routineTitles {
                    print("\(title.name)")
                    print("done: \(title.done)")
                }
                if todayData.routineTitles.isEmpty {
                    todayData.routineTitles = routineTitles
                }
                print("今日のデータのroutineTitles一覧")
                for title in todayData.routineTitles {
                    print("\(title.name)")
                    print("done: \(title.done)")
                    for routine in title.routines {
                        print("\(routine.name)")
                        print("done: \(routine.done)")
                    }
                }
            } else {
                print("今日のデータがないので新規作成")
                
                self.todayData = TodayData(timestamp: Date(), routineTitles: routineTitles)
                try? modelContext.insert(self.todayData) // SwiftDataに保存
                
            }
        }
    }
    
    private func deleteMarch12Data() {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            
            // 3/12 のデータをフィルタ
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            
            let targetDateString = "2025/03/12" // 削除対象の日付
            guard let targetDate = formatter.date(from: targetDateString) else { return }
            
            let march12Data = allDays.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: targetDate) }
            
            // 削除処理
            for data in march12Data {
                modelContext.delete(data)
            }
            
            try modelContext.save() // 削除を保存
            
            print("✅ 3/12 のデータを削除しました")
        } catch {
            print("❌ 削除に失敗: \(error.localizedDescription)")
        }
    }

    private func generateDate(year:Int, Month:Int, day:Int) -> Date{
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 11
        dateComponents.day = 26
        let calendar = Calendar.current
        guard let specificDate = calendar.date(from: dateComponents) else {
            return Date() //現時刻を返す
        }
        return specificDate
    }
    
    
    func updateRoutinesDone() {
        print("ルーティンの更新")
        
        let fetchDescriptor = FetchDescriptor<TodayData>()
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                for routine in todayData.routineTitles {
                    print("\(routine.name): \(routine.done)")
                }
                
                // すでに完了済みなら何もしない
                if let selectedRoutine = todayData.routineTitles.filter({ $0.name == routineName }).first, selectedRoutine.done == true {
                    return
                }
                
                // すべてのdoneがtrueなら morningRoutineDone を更新
                if routines.allSatisfy(\.done) {
                    
                    if let selectedRoutine = todayData.routineTitles.filter({ $0.name == routineName }).first, selectedRoutine.done == false {
                        selectedRoutine.done = true
                    }
                    
                    try modelContext.save()
                }
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func allDoneCheck() -> Bool {
        if routines.isEmpty { return false }
        return routines.allSatisfy(\.done)
    }
    
    func allReset() {
        for i in 0..<routines.count {
            routines[i].done = false
        }
    }
}

#Preview {
    DoneRoutineView(selectedTab: .constant(1))
        .modelContainer(for: TodayData.self)
        .modelContainer(for: RoutineTitle.self)
}

struct AllDone_StampView: View {
    @State private var offsetY: CGFloat = 500 // 画面下に隠しておく
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.85))
                    .frame(width: 300, height: 300) // サイズを指定
                Text("OK")
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(-40))
                    .font(.system(size: 250))

            }
            .offset(y: offsetY) // 初期位置
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                                offsetY = 0 // アニメーションで上に移動
                            }
                        }
        }
    }
}
