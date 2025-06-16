//
//  TaraRevaCalculateView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/05.
//

import SwiftUI
import RealmSwift
import FirebaseAnalytics

struct TaraRevaCalculateView: View {
    @Binding var isShowingSheet: Bool
    @ObservedRealmObject var user: User
    
    @State var moneyType: MoneyType = .expense
    
    @State var inputPrice: String = ""
    @State var inputMemo: String = ""
    @State var selectedIncomeType: IncomeType?
    @State var selectedExpenseType: ExpenseType?
    @State var isShowCalendar:Bool = false
    
    @State var isAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground) // ←背景色を指定しないとタップが通らないことがある
                        .ignoresSafeArea()
            VStack{
                InputTitleView2(isShowingSheet: $isShowingSheet, moneyType: $moneyType)
                Divider()
                Text(moneyType == .income ? "how_much_save_if_daily".localized : "how_much_reduce_if_daily".localized)
                Text(moneyType == .income ? "received_money_type".localized : "what_will_you_use".localized)
                MoneyTypeButtonsView(
                    moneyType: $moneyType,
                    selectedIncomeType: $selectedIncomeType,
                    selectedExpenseType: $selectedExpenseType
                )
                Text(moneyType == .income ? "ma_nichi_ikura_tsukau".localized : "how_much_spend_daily".localized)
//                SelectMoneyButtonListView(inputPrice: $inputPrice)
                if Locale.current.language.languageCode?.identifier == "ja" {
                    SelectMoneyButtonListView_jp(inputPrice: $inputPrice)
                } else {
                    SelectMoneyButtonListView_en(inputPrice: $inputPrice)
                }
                    
                VStack(spacing: 0){
                    Text("")
                }
                .frame(width: UIScreen.main.bounds.width)
                .frame(height: 50)
                .hideKeyboardOnTap()
                
                ScrollView {
                    if let price = Int(inputPrice) {
                        Text("continue_3_days".localized)
                        HStack {
                            PriceView(price: price, days: 3)
                            Button(action:{
                                setSavingPlan(price, 3)
                            }){
                                Text("set_as_goal".localized)
                            }
                        }
                        Text("continue_10_days".localized)
                        HStack {
                            PriceView(price: price, days: 10)
                            Button(action:{
                                setSavingPlan(price, 10)
                            }){
                                Text("set_as_goal".localized)
                            }
                        }
                        Text("continue_20_days".localized)
                        HStack {
                            PriceView(price: price, days: 20)
                            Button(action:{
                                setSavingPlan(price, 20)
                            }){
                                Text("set_as_goal".localized)
                            }
                        }
                        Text("continue_30_days".localized)
                        HStack {
                            PriceView(price: price, days: 30)
                            Button(action:{
                                setSavingPlan(price, 30)
                            }){
                                Text("set_as_goal".localized)
                            }
                        }
                    }
                }
                Spacer()
            }
            .hideKeyboardOnTap()
        }
    }
    
    func setSavingPlan(_ price: Int, _ days: Int) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToUpdate = users.filter { $0.id == user.id }.first!
        
        
        let savingPlan = SavingPlan()
        savingPlan.amount = price
        savingPlan.countDay = days
        
        try! realm.write {
            userToUpdate.savingPlans.append(savingPlan)
        }
        print("目標を作成しました")
        
        Analytics.setAnalyticsCollectionEnabled(true)
        
        Analytics.logEvent("add_savingPlan", parameters: [
                "price": price,
                "countDay": days
        ])
    }
    
    func calculateTaraReva(_ days: Int, _ price: Int) -> String {
        
        return String(days * price)
    }
    
    func updateUser(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToUpdate = users.filter { $0.id == user.id }.first!
        
        let money = Money()
        money.price = 200
        money.moneyType = .income
        money.incomeType = .monthlyPayment
        money.memo = "めもめも"
        money.timestamp = Date()
        
        try! realm.write {
            userToUpdate.moneys.append(money)
        }
    }
    
    
    func insertMoneyItem() {
        // お小遣いを追加する
        if  moneyType == .income, let priceValue = Int(inputPrice), let _ = selectedIncomeType {
            let realm = try! Realm()
            
            let users = realm.objects(User.self)
            let userToUpdate = users.filter { $0.id == user.id }.first!
            
            let newItem = Money(price: priceValue, moneyType: moneyType, incomeType: selectedIncomeType, memo: inputMemo, timestamp: Date(), userID: user.id)
            
            try! realm.write {
                userToUpdate.moneys.append(newItem)
            }
            
            selectedIncomeType = nil
            print("おこづかいを追加する")
            
            Analytics.setAnalyticsCollectionEnabled(true)
            
            Analytics.logEvent("add_allowance", parameters: [
                    "price": priceValue,
                    "moneyType": moneyType.rawValue,
                    "incomeType": selectedIncomeType?.rawValue ?? "値が取れませんでした"
                ])
            
            
            
            return
        }
        // 何に使ったか
        if moneyType == .expense, let priceValue = Int(inputPrice), let _ = selectedExpenseType {
            let realm = try! Realm()
            
            let users = realm.objects(User.self)
            let userToUpdate = users.filter { $0.id == user.id }.first!
            
            let newItem = Money(price: priceValue, moneyType: moneyType, expenseType: selectedExpenseType, memo: inputMemo, timestamp: Date(), userID: user.id)
            
            try! realm.write {
                userToUpdate.moneys.append(newItem)
            }

            selectedExpenseType = nil
            print("何に使ったか")
            Analytics.logEvent("add_allowance", parameters: [
                    "price": priceValue,
                    "moneyType": moneyType.rawValue,
                    "incomeType": selectedIncomeType?.rawValue ?? "値が取れませんでした"
                ])
            
            return
        }
    }
}

#Preview {
    TaraRevaCalculateView(isShowingSheet: .constant(true), user: User())
}

struct PriceView: View {
    var price: Int
    var days: Int
    var body: some View {
        VStack {
            HStack(spacing:0) {
//                TextField("金額を入力", text: $inputPrice)
                Text(String(price * days))
                    .font(.system(size: 30))
                    .padding(.trailing, 30)
                Text("円")
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 1) // 線の太さ
                .foregroundColor(.blue) // 線の色
                .padding(.horizontal)
        }
        .padding()
    }
}


struct InputTitleView2: View {
    @Binding var isShowingSheet: Bool
    @Binding var moneyType: MoneyType
    var body: some View {
        HStack {
            Button(action:{
                moneyType = moneyType == .income ? .expense : .income
                
            }){
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                    .padding()
            }

            
            Spacer()
            Text("calculate".localized)
                .font(.title)
                .padding()
            Spacer()
            Button(action:{
                isShowingSheet = false
            }){
                Image(systemName: "xmark")
                    .padding()
            }
            
        }
    }
}

struct MoneyTypeButtonsView: View {
    @Binding var moneyType: MoneyType
    @Binding var selectedIncomeType: IncomeType?
    @Binding var selectedExpenseType: ExpenseType?
    var body: some View {
        if moneyType == .income {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(IncomeType.allCases, id: \.self) { incomeType in
                        Button(action: {
                            
                            selectedIncomeType = incomeType
                        } ) {
                            Text(incomeType.localizedName)
                                .foregroundColor(incomeType == selectedIncomeType ? .white :.blue)
                                .modifier(BorderedTextChangeColor(isSelected: incomeType == selectedIncomeType))
                        }
                    }
                }
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ExpenseType.allCases, id: \.self) { expenseType in
                        Button(action: {
                            selectedExpenseType = expenseType
                        } ) {
                            Text(expenseType.localizedName)
                                .foregroundColor(expenseType == selectedExpenseType ? .white :.blue)
                                .modifier(BorderedTextChangeColor(isSelected: expenseType == selectedExpenseType))
                        }
                    }
                }
            }
        }
    }
}
