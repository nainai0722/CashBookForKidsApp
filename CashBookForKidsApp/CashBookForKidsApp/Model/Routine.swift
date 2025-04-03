//
//  Routine.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import Foundation
import SwiftData

@Model
final class Routine {
    var id : UUID?
    var name: String
    var done: Bool
    var imageName: String
    
    init(id: UUID? = nil, name: String, done: Bool, imageName: String) {
        self.id = id
        self.name = name
        self.done = done
        self.imageName = imageName
    }
    
    static let mockWearRoutine = Routine(id: UUID(), name: "きがえる", done: true, imageName: "wear")
    static let mockEatRoutine = Routine(id: UUID(), name: "たべる", done: false, imageName: "eat")
    static let mockEToiletRoutine = Routine(id: UUID(), name: "トイレ", done: false, imageName: "toilet")
    static let mockBottleRoutine = Routine(id: UUID(), name: "水筒", done: false, imageName: "bottle")
    static let mockGoodsRoutine = Routine(id: UUID(), name: "給食セット", done: false, imageName: "goods")
    static let scale = Routine(id: UUID(), name: "けんおん", done: false, imageName: "scale")
    static let mock2 = Routine(id: UUID(), name: "カレンダー", done: false, imageName: "calender")
    static let mock3 = Routine(id: UUID(), name: "お風呂", done: false, imageName: "bath")
    static let mock4 = Routine(id: UUID(), name: "お風呂", done: false, imageName: "bath")
    static let mock5 = Routine(id: UUID(), name: "かみをかわかす", done: false, imageName: "dry")
    static let mock6 = Routine(id: UUID(), name: "はみがきをする", done: false, imageName: "hamigaki")
    
    static let mockThreeRoutines: [Routine] = [mockEatRoutine, mockEToiletRoutine, mockWearRoutine]
    
    static let mockMorningRoutines: [Routine] = [
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine,
        .mockBottleRoutine,
        .mockGoodsRoutine,
        mock6
        
    ]
    
    static let mockEveningRoutines: [Routine] = [
        mock2,
        mock3,
        mock5
    ]
    
    static let mockSleepTimeRoutines: [Routine] = [
        mockEToiletRoutine,
        mock3,
        mock2,
        mock5,
        mock6
    ]
}


enum RoutineType: String, CaseIterable, Codable {
    case morning = "あさのしたく"
    case evening = "ゆうがたのしたく"
    case sleepTime = "寝るまえのしたく"
    
}
