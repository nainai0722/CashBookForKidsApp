//
//  RoutineTitle.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import Foundation
import SwiftData

@Model
final class RoutineTitle: Identifiable {
    var id: UUID
    var name: String
    var routines: [Routine] = []
    var done: Bool
    
    init(id: UUID, name: String, routines: [Routine], done: Bool) {
        self.id = id
        self.name = name
        self.routines = routines
        self.done = done
    }
    
    init(name: String) {
        self.name = name
        self.id = UUID()
        self.done = false
        self.routines = Routine.mockThreeRoutines
    }
    init(name: String, routines: [Routine]) {
        self.name = name
        self.id = UUID()
        self.done = false
        self.routines = routines
    }
}


