//
//  EditRoutineTitleView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import SwiftUI

struct EditRoutineTitleView_old: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var routineTitle: RoutineTitle
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("\(routineTitle.name)")
        Text("\(routineTitle.done)")
        
        ForEach(routineTitle.routines, id: \.id) { routine in
            HStack {
                Text("\(routine.name)")
                Text("\(routine.done)")
            }
        }
        
    }
}

#Preview {
    EditRoutineTitleView_old(routineTitle: .constant(RoutineTitle(name: "test")))
        .modelContainer(for: RoutineTitle.self)
}
