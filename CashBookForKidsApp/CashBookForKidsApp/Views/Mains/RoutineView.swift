//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    @State var routineTitle:RoutineTitle = RoutineTitle(name: "ゆうがたのしたく", routines: Routine.mockEveningRoutines)
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach($routineTitle.routines,id:\.id) {$routine in
                        NavigationLink {
                            EditRoutineView(
                                routineTitle: $routineTitle,
                                routine: Binding<Routine?>(
                                    get: { routine },      // 通常のRoutineをオプショナルとして取得
                                    set: { routine = $0! }  // 更新を反映
                                )
                            )
                        } label: {
                            Text(routine.name)
                        }

                    }
                    NavigationLink {
                        EditRoutineView(
                            routineTitle: $routineTitle,
                            routine: .constant(nil) 
                        )
                    } label: {
                        Text("新しいしたくを追加する")
                    }
                }
            }
        }
        .navigationTitle(Text(routineTitle.name))
    }
}

#Preview {
    RoutineListView()
        .modelContainer(for: RoutineTitle.self)
}
