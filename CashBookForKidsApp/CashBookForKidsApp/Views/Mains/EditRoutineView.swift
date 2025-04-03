//
//  EditRoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/22.
//

import SwiftUI

struct EditRoutineView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var routineTitle: RoutineTitle
    @Binding var routine:Routine?
    var body: some View {
        VStack {
            TextField("タイトルを入力", text: Binding(
                            get: { routine?.name ?? "" },  // nilなら空文字を使う
                            set: { routine?.name = $0 }    // routineがnilでなければ更新
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
            Button(action:{
                if let routine = routine {
                    saveChanges()
                } else {
                    addRoutine()
                }
            }){
                if let routine = routine {
                    Text("更新")
                } else {
                    Text("保存")
                }
            }
        }
    }
    
    func saveChanges() {
        // 更新処理
        do {
            try modelContext.save()
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
    func addRoutine() {
        let newRoutine = Routine(name: "新しいルーティン", done: false, imageName: "bath")
        // 更新処理
        do {
            try modelContext.save()
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
    func addRoutineTitle(name: String) {
        let newRoutineTitle = RoutineTitle(name: name, routines: Routine.mockThreeRoutines)
        do {
            try modelContext.insert(newRoutineTitle)
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    EditRoutineView(
        routineTitle: .constant(RoutineTitle(name: "ゆうがたのしたく", routines: Routine.mockEveningRoutines)),
        routine: .constant(Routine.mockEveningRoutines[0])
    )
    .modelContainer(for: RoutineTitle.self)
}
