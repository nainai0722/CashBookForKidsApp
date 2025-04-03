//
//  MoneyInputView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/05.
//

import SwiftUI

struct MoneyInputView: View {
    @Binding var isShowingSheet: Bool
    @Environment(\.modelContext) private var modelContext
    @State var moneyType: MoneyType = .expense
    
    @State var inputPrice: String = ""
    @State var inputMemo: String = ""
    @State var selectedIncomeType: IncomeType?
    @State var selectedExpenseType: ExpenseType?
    @State var selectedDate: Date = Date()
    @State var isShowCalendar:Bool = false
    
    var body: some View {
        VStack{
            InputTitleView(isShowingSheet: $isShowingSheet, moneyType: $moneyType, selectedIncomeType: $selectedIncomeType, selectedExpenseType: $selectedExpenseType)
            Divider()
            Text(moneyType == .income ? "もらったお金のしゅるい" : "何につかった？")
            
            if moneyType == .income {

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
            
            InputPriceView(inputPrice: $inputPrice)
            SelectMoneyButtonListView(inputPrice: $inputPrice)
            
            InputMemoView(inputMemo: $inputMemo)
            
            Button(action: {
                isShowCalendar.toggle()
            }){
                VStack {
                    Text("登録する日付は\(selectedDate.formattedYearMonthDayString)")
                    
                }
                .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .blue, fontType: .headline))
            }

            Button(action: {
                insertMoneyItem()
                isShowingSheet = false
            }){
                Text("追加する")
                    .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .blue, fontType: .title))
            }
            Spacer()

        }
        .overlay(){
            selectDateView(selectedDate: $selectedDate, isShowCalendar: $isShowCalendar)
        }
    }
    
    func insertMoneyItem() {
        if (selectedIncomeType == nil && selectedExpenseType == nil), let priceValue = Int(inputPrice) {
            print("エラー: 追加するお小遣いまたは支出の種類を指定してください。\(priceValue)円")
            return
        } else {
            print("保存処理へ")
        }
        // お小遣いを追加する
        if  moneyType == .income, let priceValue = Int(inputPrice), let _ = selectedIncomeType {
            let newItem = Money(price: priceValue, moneyType: moneyType, incomeType: selectedIncomeType, memo: inputMemo, timestamp: selectedDate)
            modelContext.insert(newItem)
            try? modelContext.save()
            print("おこづかいを追加する")
            return
        }
        // 何に使ったか
        if moneyType == .expense, let priceValue = Int(inputPrice), let _ = selectedExpenseType {
            let newItem = Money(price: priceValue, moneyType: moneyType, expenseType: selectedExpenseType, memo: inputMemo, timestamp: selectedDate)
            modelContext.insert(newItem)
            selectedExpenseType = nil
            print("何に使ったか")
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
            
            let newItem = Money(price: 100, moneyType: .income, incomeType: .familySupport, memo: "メモメモ", timestamp: date)
            modelContext.insert(newItem)
            try? modelContext.save()
        }
    }
    
}

#Preview {
    MoneyInputView(isShowingSheet: .constant(true))
}

import SwiftUI

struct BorderedTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding() // テキストの周りに余白を追加
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2) // 枠線を追加
                    )
            )
    }
}

//struct CustomButtonLayout:ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .frame(width: UIScreen.main.bounds.width * 0.8, height: 70)
//            .buttonStyle(.borderedProminent)
//            .tint(Color.blue)
//            .foregroundColor(.white)
//            .font(.title)
//            .cornerRadius(15)
//            .shadow(radius: 5) // 影をつける
//            .padding()
//    }
//}

struct BorderedTextChangeColor: ViewModifier {
    var isSelected: Bool
    func body(content: Content) -> some View {
        content
            .padding() // テキストの周りに余白を追加
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color.white : Color.blue, lineWidth: 2)
                    )
            )
    }
}

// 日付を変更する画面
struct selectDateView: View {
    @Binding var selectedDate: Date
    @Binding var isShowCalendar: Bool
    var body: some View {
        ZStack {
            VStack {
                Text("変更する日付を選ぶ")
                DatePicker(
                    "\(selectedDate.formattedYearMonthDayString)",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                Button(action:{
                    isShowCalendar = false
                }){
                    Text("閉じる")
                }
            }
            .frame(width: 300, height: 400)
            .padding()
            .cornerRadius(0.5)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(isShowCalendar ? 1 : 0)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.gray.opacity(0.4).edgesIgnoringSafeArea(.all))
        .opacity(isShowCalendar ? 1 : 0)
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

struct InputMemoView: View {
    @Binding var inputMemo: String
    var body: some View {
        VStack {
            HStack(spacing:0) {
                TextField("メモを入力", text: $inputMemo)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing) // テキスト入力も左寄せ
                    .font(.system(size: 30))
                    .padding(.trailing, 45)
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

struct SelectMoneyButtonListView: View {
    @Binding var inputPrice: String
    let moneyBottonContents : [Int] = [100,200,400,300,500,700,1000]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(moneyBottonContents, id: \.self) { content in
                    Button(action: {
                        inputPrice = String(content)
                    } ) {
                        Text("\(content)円")
                            .modifier(BorderedTextModifier())
                    }
                }
            }
        }
    }
}

struct InputTitleView: View {
    @Binding var isShowingSheet: Bool
    @Binding var moneyType: MoneyType
    @Binding var selectedIncomeType: IncomeType?
    @Binding var selectedExpenseType: ExpenseType?
    var body: some View {
        HStack {
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
            Spacer()
            Text("記録する")
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
