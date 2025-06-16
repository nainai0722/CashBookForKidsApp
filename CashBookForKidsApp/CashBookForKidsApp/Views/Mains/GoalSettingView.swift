//
//  GoalSettingView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/08.
//

import SwiftUI
import RealmSwift

struct GoalSettingView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var moneys: [Money]
//    @Query var userInfo:[UserInfo]
    @ObservedResults(Money.self) var moneys
    @ObservedResults(UserInfo.self) var userInfos
    @State var total :Int = 1000
    @State var goal: GoalData = GoalData.mockGoal
    var goals :[GoalData] = GoalData.mockGoalsList
    
    var isAchieved :Bool {
        if result <= 0 {
            return true
        }
        return goal.isAchieved
    }
    
    var result: Int {
        return goal.amount - total > 0 ? goal.amount - total : 0
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle().fill(Color.green)
                    .cornerRadius(20)
                VStack {
                    Text("goal_setting_screen".localized)
                        .font(.system(size: 30))
                        .padding()
                    Text("current_goal".localized(with: goal.amount))
                        .padding()
                    Text(isAchieved ? "goal_achieved".localized : "remaining_amount".localized(with: result))
                    
                    VStack {
                        if isAchieved {
//                            BubbleView(text: "次は\(nextGaolSetting().amount)円を目指そう")
//                                .foregroundStyle(.green)
                            Button (action:{
//                                goal = nextGaolSetting()
                            })
                            {
                                Text("set_next_goal".localized)
                                
                            }
                        }
                    }
                }
                .foregroundStyle(.white)
                
            }
            .frame(height: 200)
            .padding(20)
            .padding(.top, 50)
            Spacer()
        }
    }
    
    
//    func nextGaolSetting() ->  Goal{
//        guard let nextGoal = goals.filter { $0.level == goal.level + 1}.first else {
//            return goal
//        }
//        print("nextGaolLevel: \(nextGoal.level) amount:\(nextGoal.amount)")
//        return nextGoal
//    }

}

#Preview {
    GoalSettingView()
}
