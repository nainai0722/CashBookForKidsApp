//
//  MoneyInsertView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/05.
//

import SwiftUI
import RealmSwift
import FirebaseAnalytics

#Preview {
    MoneyInsertView(isShowFullScreen: .constant(true),editMoney: .constant(MoneyData()), user: User())
}

#Preview("Loading") {
    SelectIncomeMoneyButtonListView(inputPrice: .constant("100"))
    InputPriceView(inputPrice: .constant(""))
}

struct MoneyInsertView: View {
    @Binding var isShowFullScreen: Bool
    @Binding var editMoney: MoneyData?
//    @Binding var refreshID :UUID
    @ObservedResults(Money.self) var moneys
    @ObservedRealmObject var user: User
    
    @State var moneyType: MoneyType = .expense
    
    @State var inputPrice: String = ""
    @State var inputMemo: String = ""
    @State var selectedIncomeType: IncomeType?
    @State var selectedExpenseType: ExpenseType?
    @State var selectedDate: Date = Date()
    @State var isShowCalendar:Bool = false
    
    @State var isShowHelp: Bool = false
    
    @State var isAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                            .ignoresSafeArea()
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                            }
            VStack(alignment: .leading){
                InsertTitle(isShowHelp: $isShowHelp, isShowFullScreen: $isShowFullScreen)
                Divider()
                
                Button(action:{
                    if moneyType == .income {
                        selectedIncomeType = nil
                    } else {
                        selectedExpenseType = nil
                    }
                    moneyType = moneyType == .income ? .expense : .income
                    
                }){
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                        .padding()
                }
                .opacity(editMoney == nil ? 1 : 0)
                .disabled(editMoney != nil)
                
                Text("日付")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 10)
                HStack {
                    Text("\(selectedDate.formattedYearMonthDayString)")
                        .padding(.leading, 10)
                    Button(action: {
                        isShowCalendar.toggle()
                    }){
                        VStack {
                            Text("変更する")
                                .modifier(CustomColorFontSizeButton(fontSize: 15, color: .blue))
                            
                        }
                    }
                    Spacer()
                }
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 1)
                
                Text("金額")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 10)
                
                InputPriceView(inputPrice: $inputPrice)
                
                SelectIncomeMoneyButtonListView(inputPrice: $inputPrice)
                    .padding(.leading, 10)
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 1)
                    .padding(.leading, 10)
                
                Text("カテゴリー")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 10)
                CategoryButtonList(moneyType: moneyType, selectedIncomeType: $selectedIncomeType, selectedExpenseType: $selectedExpenseType)
                    .padding(.leading, 10)
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 1)
                    .padding(.leading, 10)
                
                Text("メモ")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 10)
                
                InputMemoView(inputMemo: $inputMemo)
                    .padding(.leading, 10)
                
                
                Spacer()
                Button(action: {
                    if selectedIncomeType == nil && selectedExpenseType == nil && Int(inputPrice) == nil {
                        isAlert.toggle()
                        return
                    }

                    if let editMoney = editMoney {
                        updateMoneyItem(editMoney)
                    } else {
                        insertMoneyItem()
                    }
                    isShowFullScreen = false
                }){
//                    Text("保存する")
                    Text((editMoney != nil) ? "書き換える" : "追加する")
                        .modifier(CustomButtonWithColorFont(textColor: .white, backGroundColor: .blue, fontSize: 20))
                }
            }
            .fullScreenCover(isPresented: $isShowHelp, onDismiss: {
                
            }, content: {
                InsertHelp(isShowHelp: $isShowHelp)
            })
            .overlay(){
                selectDateView(selectedDate: $selectedDate, isShowCalendar: $isShowCalendar)
            }
            .onAppear(){
                if let editMoney = editMoney {
                    inputPrice = String(editMoney.price)
                    
                    selectedIncomeType = editMoney.incomeType
                    selectedExpenseType = editMoney.expenseType
                    
                    inputMemo = editMoney.memo != nil ? editMoney.memo! : ""
                    selectedDate = editMoney.timestamp
                }
            }
        }
    }
    
    func insertMoneyItem() {
        // お小遣いを追加する
        if  moneyType == .income, let priceValue = Int(inputPrice), let _ = selectedIncomeType {
            let realm = try! Realm()
            
            let users = realm.objects(User.self)
            let userToUpdate = users.filter { $0.id == user.id }.first!
            
            let newItem = Money(price: priceValue, moneyType: moneyType, incomeType: selectedIncomeType, memo: inputMemo, timestamp: selectedDate, userID: userToUpdate.id)
            
            try! realm.write {
                userToUpdate.moneys.append(newItem)
            }
            
            selectedIncomeType = nil
//            refreshID = UUID()
            print("おこづかいを追加する")
            
            Analytics.setAnalyticsCollectionEnabled(true)
            
            Analytics.logEvent("add_allowance", parameters: [
                    "price": priceValue,
                    "moneyType": moneyType.rawValue,
                    "memo": inputMemo,
                    "incomeType": selectedIncomeType?.rawValue ?? "値が取れませんでした"
            ])
            return
        } else {
            print("お小遣いの追加失敗")
        }
        // 何に使ったか
        if moneyType == .expense, let priceValue = Int(inputPrice), let _ = selectedExpenseType {
            let realm = try! Realm()
            
            let users = realm.objects(User.self)
            let userToUpdate = users.filter { $0.id == user.id }.first!
            
            let newItem = Money(price: priceValue, moneyType: moneyType, expenseType: selectedExpenseType, memo: inputMemo, timestamp: selectedDate, userID: userToUpdate.id)
            
            try! realm.write {
                userToUpdate.moneys.append(newItem)
            }

            selectedExpenseType = nil
//            refreshID = UUID()
            print("何に使ったか")
            Analytics.logEvent("add_allowance", parameters: [
                    "price": priceValue,
                    "moneyType": moneyType.rawValue,
                    "memo": inputMemo,
                    "incomeType": selectedExpenseType?.rawValue ?? "値が取れませんでした"
                ])
            
            return
        }
    }
    
    func updateMoneyItem(_ editMoney: MoneyData) {
        // お小遣いを追加する
        if  moneyType == .income,
            let priceValue = Int(inputPrice),
            let selectedType = selectedIncomeType,
            let moneyToUpdate = user.moneys.first(where: { $0.id == editMoney.id })
        {
            
            let realm = try! Realm()

            // thawして、解凍されたオブジェクトに対して書き込みを行う
            if let thawedMoney = moneyToUpdate.thaw() {
                try! realm.write {
                    thawedMoney.price = priceValue
                    thawedMoney.moneyType = moneyType
                    thawedMoney.incomeType = selectedType
                    thawedMoney.memo = inputMemo
                    thawedMoney.timestamp = selectedDate
                    print("おこづかいを更新した")
                    Analytics.logEvent("update_allowance", parameters: [
                            "price": priceValue,
                            "moneyType": moneyType.rawValue,
                            "memo": inputMemo,
                            "incomeType": selectedIncomeType?.rawValue ?? "値が取れませんでした"
                    ])
//                    refreshID = UUID()
                }
            } else {
                print("thawに失敗しました（オブジェクトが無効になっている可能性あり）")
            }


            selectedIncomeType = nil
            return
        }
        // 何に使ったか
        if  moneyType == .expense,
            let priceValue = Int(inputPrice),
            let selectedType = selectedExpenseType,
            let moneyToUpdate = user.moneys.first(where: { $0.id == editMoney.id })
        {
            
            let realm = try! Realm()

            // thawして、解凍されたオブジェクトに対して書き込みを行う
            if let thawedMoney = moneyToUpdate.thaw() {
                try! realm.write {
                    thawedMoney.price = priceValue
                    thawedMoney.moneyType = moneyType
                    thawedMoney.expenseType = selectedType
                    thawedMoney.memo = inputMemo
                    thawedMoney.timestamp = selectedDate
                    print("使ったお金を更新した")
                    Analytics.logEvent("update_allowance", parameters: [
                            "price": priceValue,
                            "moneyType": moneyType.rawValue,
                            "memo": inputMemo,
                            "incomeType": selectedExpenseType?.rawValue ?? "値が取れませんでした"
                    ])
//                    refreshID = UUID()
                }
            } else {
                print("thawに失敗しました（オブジェクトが無効になっている可能性あり）")
            }

            selectedIncomeType = nil
            return
        }
    }
    
    func addMoneyByDate() {
        let calendar = Calendar.current
        if let specificDate = calendar.date(from: DateComponents(year: 2025, month: 2, day: 1)) {
            addMoneyByDate(by: specificDate)
        }
    }
    private func addMoneyByDate(by date: Date) {
        withAnimation {
            let realm = try! Realm()
            
            let users = realm.objects(User.self)
            let userToUpdate = users.filter { $0.id == user.id }.first!
            
            let newItem = Money(price: 100, moneyType: .income, incomeType: .familySupport, memo: "メモメモ", timestamp: date, userID: userToUpdate.id)
            
            try! realm.write {
                userToUpdate.moneys.append(newItem)
//                refreshID = UUID()
            }
        }
    }
}


struct InputPriceView: View {
    @Binding var inputPrice: String
    var body: some View {
        VStack {
            HStack(spacing:0) {
                TextField("金額を入力", text: $inputPrice)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing) // テキスト入力も左寄せ
                    .font(.system(size: 30))
                    .padding(.trailing, 20)
                Text("円")
                Button(action: {
                        inputPrice = ""
                }){
                    Image(systemName: "xmark.circle.fill")
                        .padding(.leading, 10)
                        .foregroundStyle(.gray)
                }
                .opacity(inputPrice.isEmpty ? 0 : 1)
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(inputPrice.isEmpty ? Color.gray : Color.blue)
                .padding(.horizontal)
        }
        .padding()
    }
}


struct SelectIncomeMoneyButtonListView: View {
    @Binding var inputPrice: String
    let moneyBottonContents : [Int] = [100,200,400,300,500,700,1000]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(moneyBottonContents, id: \.self) { content in
                    Button(action: {
                        if let inputPriceInt = Int(inputPrice.isEmpty ? "0" : inputPrice) {
                            inputPrice = String(inputPriceInt + content)
                        }
                    } ) {
                        Text("+\(content)円")
                            .modifier(BorderedTextModifier())
                    }
                }
            }
        }
    }
}

struct CategoryButtonList:View {
    let moneyType:MoneyType
    @Binding var selectedIncomeType:IncomeType?
    @Binding var selectedExpenseType:ExpenseType?
    var body: some View {
        VStack {
            if moneyType == .income {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(IncomeType.allCases, id: \.self) { incomeType in
                                Button(action: {
                                    selectedIncomeType = incomeType
                                } ) {
                                    Text(incomeType.rawValue)
                                        .foregroundColor(incomeType == selectedIncomeType ? .white :.blue)
                                        .modifier(BorderedTextChangeColor(isSelected: incomeType == selectedIncomeType))
                                }
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
                                Text(expenseType.rawValue)
                                    .foregroundColor(expenseType == selectedExpenseType ? .white :.blue)
                                    .modifier(BorderedTextChangeColor(isSelected: expenseType == selectedExpenseType))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct InsertHelp: View {
    @Binding var isShowHelp: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action:{
                    withAnimation(){
                        isShowHelp = false
                    }
                }){
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 24))
                        .foregroundStyle(.blue)
                        
                }
                .padding(.leading, 30)
                Spacer()
                Text("使い方")
                    .font(.system(size: 24))
                Spacer()
                Image(systemName: "xmark.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(.clear)
                    .padding(.trailing, 30)
            }
            Divider()
            Spacer()
        }
        
    }
}

struct InsertTitle: View {
    @Binding var isShowHelp: Bool
    @Binding var isShowFullScreen: Bool
    var body: some View {
        HStack {
            Button(action: {
                isShowFullScreen = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.gray)
                    .padding(.leading, 30)
            }
            
            
            Spacer()
            Text("お金の記録をつける")
                .font(.system(size: 24))
            Spacer()
            
            Button(action:{
                withAnimation(){
                    isShowHelp.toggle()
                }
            }){
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
                    .padding(.trailing, 30)
            }
            
        }
    }
}

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
