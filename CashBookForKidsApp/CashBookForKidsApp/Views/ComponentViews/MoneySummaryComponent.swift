//
//  MoneySummaryComponent.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/03.
//

import SwiftUI
import SwiftData

struct MoneySummaryComponent: View {
    @Binding var isShowingGoalSetting: Bool
    @Binding var isShowingMoneyDetail: Bool
    @Binding var total: Int
    @Binding var goal: Goal
    
    var isGoalAchieved: Bool {
        return goal.amount > total
    }
    
    var amountToGoal: Int {
        if isGoalAchieved {
            return goal.amount - total
        }
        return 0
    }
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.green)
                .cornerRadius(20)
            
            VStack(alignment:.leading) {
                HStack {
                    Spacer()
                    Button(action:{
                        isShowingGoalSetting = true
                        isShowingMoneyDetail = false
                        print("isShowingGoalSetting: \(isShowingGoalSetting)")
                    }){
                        
                        BubbleView(text: goalAchieved())
                            .foregroundStyle(.green)
                    }
                }
                HStack {
                    Text("おこづかい")
                        .font(.headline)
                    Spacer()
                    Text(currentDateString + "現在")
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.bottom, 20)
                Text("\(total)円")
                    .font(.title)
            }
            .foregroundStyle(.white)
            .padding(.horizontal,40)
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action:{
                        print("お金の詳細を見る")
                        isShowingMoneyDetail = true
                        isShowingGoalSetting = false
                    }){
                        
                        VStack {
                            Image("money_bag_color")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            Text("こまかく見る")
                        }
                        .padding([.bottom,.trailing],10)
                    }
                }
            }
        }
        .frame(height: 200)
        .padding(20)
    }
    
    var currentDateString:String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM dd HH:mm"
        let formattedDate = formatter.string(from: Date())
        return formattedDate
    }
    
    func goalAchieved() -> String {
        if isGoalAchieved {
            return "目標まであと\(amountToGoal)円"
        } else {
            return "達成しました"
        }
    }
}

struct MoneySummaryComponent_Test: View {
    @Binding var isShowingGoalSetting: Bool
    @Binding var total: Int
    @Binding var goal: Goal
    
    var isGoalAchieved: Bool {
        return goal.amount > total
    }
    
    var amountToGoal: Int {
        if isGoalAchieved {
            return goal.amount - total
        }
        return 0
    }
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.green)
                .cornerRadius(20)
        }
        .frame(height: 200)
        .padding(20)
    }
    
    var currentDateString:String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM dd HH:mm"
        let formattedDate = formatter.string(from: Date())
        return formattedDate
    }
}

#Preview {
    MoneySummaryComponent(
        isShowingGoalSetting: .constant(true),
        isShowingMoneyDetail: .constant(true),
        total: .constant(1000),goal: .constant(Goal.mockGoal))
    MoneySummaryComponent_Test(
        isShowingGoalSetting: .constant(true),
        total: .constant(1000),goal: .constant(Goal.mockGoal))
}
