//
//  MultiUserTabView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import SwiftUI
import RealmSwift
import UniformTypeIdentifiers
import FloatingButton

struct MultiUserTabView: View {
    @State var isShowFullScreen: Bool = false
    @ObservedResults(User.self) var users

    var body: some View {
        ZStack {
            VStack {
                TabView {
                    ForEach(users) { user in
                        UserMoneyListView(user: user)
                            .tabItem {
                                Text(user.name)
                            }
                    }
                    SettingView()
                        .tabItem {
                            Text("設定")
                        }
                }
                .fullScreenCover(isPresented: $isShowFullScreen) {
                    RealmControl()
                }
            }
            // ボタンを設置した・・・
            ScreenStraight2()
        }
        .onAppear {
            isShowFullScreen = users.isEmpty ? true : false
        }
    }
}


#Preview {
    MultiUserTabView()
}

struct ScreenStraight2: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        let mainButton2 = MainButton(imageName: "cloud.fill", colorHex: "eb3b5a")
        let buttonsImage = MockData.iconImageNames.enumerated().map { index, value in
            IconButton(imageName: value, action: {
                handleButtonTap(index: index)
            }, color: MockData.colors[index])
        }


        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: buttonsImage)
            .straight()
            .direction(.top)
            .delays(delayDelta: 0.1)

        return VStack {
            Spacer()
            HStack {
                Spacer()
                menu2
            }
            .padding(20)
        }
    }
    func handleButtonTap(index: Int) {
        switch index {
        case 0:
            print("💡 ボタン0が押された！何かの登録処理など")
        case 1:
            print("📨 ボタン1が押された！メッセージ送信？")
        case 2:
            print("🔔 ボタン2が押された！通知を出す？")
        default:
            print("🤷‍♀️ 未定義のボタンが押された")
        }
    }
}

struct AnimatedButtonView: View {
    @State private var isTapped = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                isTapped.toggle()
            }
        }) {
            Text("Tap Me")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(isTapped ? Color.blue : Color.green)
                .cornerRadius(10)
                .scaleEffect(isTapped ? 1.2 : 1.0)
        }
    }
}

struct UserMoneyListView: View {
    @State private var totalMoney: Int = 0
    
    @ObservedRealmObject var user: User
    
    @State private var isShowingIncomeSheet = false
    @State private var isShowingExpenseSheet = false
    @State private var isShowingTaraRevaCalculateSheet = false
    
    @State private var isShowingGoalSetting = false
    @State private var isShowingMoneyDetail = false
    
    @State private var goal: GoalData = GoalData.mockGoal
    @State private var editMoney: MoneyData? = nil
    
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(getSavingPlan())
                //　ふやす減らすボタン
                ButtonView(
                    editMoney: $editMoney,
                    isShowingIncomeSheet: $isShowingIncomeSheet,
                    isShowingExpenseSheet:$isShowingExpenseSheet,
                    isShowingTaraRevaCalculateSheet: $isShowingTaraRevaCalculateSheet
                )
                MoneySummaryComponent(
                    isShowingGoalSetting: $isShowingGoalSetting,
                    isShowingMoneyDetail: $isShowingMoneyDetail,
                    total: $totalMoney,
                    goal: $goal
                )
                .navigationDestination(isPresented: $isShowingGoalSetting) {
                    GoalSettingView(total: totalMoney, goal: goal)
                }
                .navigationDestination(isPresented: $isShowingMoneyDetail) {
                    MoneyChartView(user: user)
                }
                
                List {
                    ForEach(user.moneys) { money in
                        MoneyInfoCell(money: castMoneyData(to: money))
                            .onTapGesture {
                                editMoney = castMoneyData(to: money)
                                if money.moneyType == .expense {
                                    isShowingExpenseSheet.toggle()
                                } else {
                                    isShowingIncomeSheet.toggle()
                                }
                            }
                    }
                    .onDelete { indexSet in
                        deleteMoney(at: indexSet, for: user)
                    }
                }
                .listStyle(.plain)
                .id(refreshID) // ←これ追加
            }
        }
        .sheet(isPresented: $isShowingIncomeSheet) {
            MoneyInputView(
                isShowingSheet: $isShowingIncomeSheet,
                editMoney: $editMoney, refreshID: $refreshID,
                user: user,
                moneyType: .income
            )
        }
        .sheet(isPresented: $isShowingExpenseSheet) {
            MoneyInputView(
                isShowingSheet: $isShowingExpenseSheet,
                editMoney: $editMoney, refreshID: $refreshID,
                user: user,
                moneyType: .expense
            )
        }
        .sheet(isPresented: $isShowingTaraRevaCalculateSheet) {
            TaraRevaCalculateView(
                isShowingSheet: $isShowingTaraRevaCalculateSheet,
                user: user
            )
        }
        .onChange(of: refreshID) { _ in
            getTotalMoney()
            print("リフレッシュのたびに呼び出し")
        }
        .onAppear {
            getTotalMoney()
            print("画面表示の際に呼び出し")
        }
    }
    
    /// 目標にしている金額を取得する
    /// - Returns: 目標の金額
    func getSavingPlan() -> String {
        let savingPlan = user.savingPlans.where {$0.isAchieved == false}.first
        if let savingPlan = savingPlan {
            return String(savingPlan.amount)
        }
        return "目標はなし"
    }
    
    func getTotalMoney() {
        totalMoney = user.moneys.reduce(0) { result, money in
           if money.moneyType == .income {
               return result + money.price
           } else {
               return result - money.price
           }
       }
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
    
    func deleteMoney(at offsets: IndexSet, for user: User) {
        let realm = try! Realm()

        // thaw して編集可能な状態に
        guard let thawedUser = user.thaw() else { return }

        try! realm.write {
            for index in offsets {
                let moneyToDelete = thawedUser.moneys[index]
                realm.delete(moneyToDelete)
            }
        }
    }
    
    func castMoneyData(to money: Money) -> MoneyData{
        let moneyData = MoneyData()
        moneyData.id = money.id
        moneyData.price = money.price
        moneyData.moneyType = money.moneyType
        moneyData.incomeType = money.incomeType
        moneyData.expenseType = money.expenseType
        moneyData.memo = money.memo
        moneyData.timestamp = money.timestamp
        return moneyData
    }
}

#Preview("モックたろう") {
    UserMoneyListView(user: addUser("モックたろう"))
}

#Preview("テストユーザー") {
    PreviewProviderForUserMoneyListView.preview
}

extension Date_Extensions {
    static var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    static var today: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    
}

private struct PreviewProviderForUserMoneyListView {
    static var preview: some View {
        let user = User()
        user.name = "プレビュー太郎"
        user.createdAt = Date()

        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
        try! realm.write {
            realm.add(user)
        }

        return UserMoneyListView(user: user)
    }
}



func addUser(_ name: String) -> User{
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
    
    // すでに同じ名前のユーザーがいるかチェック
    if realm.objects(User.self).filter("name == %@", name).first != nil {
        print("同じ名前のユーザーが存在します。追加をキャンセルします。")
        return User()
    }
    
    let child = User()
    child.name = name
    
    try! realm.write {
        realm.add(child)
        print(child.id)
        
    }
    return child
}

struct ButtonView: View {
    @Binding var editMoney: MoneyData?
    @Binding var isShowingIncomeSheet: Bool
    @Binding var isShowingExpenseSheet: Bool
    @Binding var isShowingTaraRevaCalculateSheet: Bool
    var body: some View {
        HStack {
            Button(action: {
                editMoney = nil
                isShowingIncomeSheet.toggle()
            }){
                Text("ふやす")
                    .modifier(CustomGreenButton(fontType: .headline))
            }
            Button(action: {
                editMoney = nil
                isShowingExpenseSheet.toggle()
            }){
                Text("へらす")
                    .modifier(CustomGreenButton(fontType: .headline))
            }
            Button(action: {
                editMoney = nil
                isShowingTaraRevaCalculateSheet.toggle()
            }){
                Text("たられば計算")
                    .modifier(CustomGreenButton(fontType: .headline))
            }
        }
    }
}

struct FileInfo: Identifiable {
    var id: String { name }
    let name: String
    let fileType: UTType
}

struct ConfirmImportAlert: View {
    @State private var alertDetails: FileInfo?
    var body: some View {
        Button("Show Alert") {
            alertDetails = FileInfo(name: "MyImageFile.png",
                                    fileType: .png)
        }
        .alert(item: $alertDetails) { details in
            Alert(title: Text("Import Complete"),
                  message: Text("""
                    Imported \(details.name) \n File
                    type: \(details.fileType.description).
                    """),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct Heart {
    var isFavorite: Bool = false
}


#Preview {
    ContextMenuMenuItems()
}

//private let menuItems = ContextMenu {
//    Button {
//        // Add this item to a list of favorites.
//        
//    } label: {
//        Label("Add to Favorites", systemImage: "heart")
//    }
//    Button {
//        // Open Maps and center it on this item.
//    } label: {
//        Label("Show in Maps", systemImage: "mappin")
//    }
//}

private struct ContextMenuMenuItems: View {
    @State private var shouldShowMenu = true
    @State private var isFavorited = false

    var body: some View {
        VStack {
            Text("Turtle Rock")
                .contextMenu {
                    Button {
                        isFavorited.toggle()
                    } label: {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                    Button {
                        // Show in Maps の処理
                    } label: {
                        Label("Show in Maps", systemImage: "mappin")
                    }
                }


            HStack {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                Text("お気に入り")
            }
        }
    }
}

#Preview("ControlSize") {
    ControlSize()
}

struct ControlSize: View {
    var body: some View {
        VStack {
            MyControls(label: "Mini")
                .controlSize(.mini)
            MyControls(label: "Small")
                .controlSize(.small)
            MyControls(label: "Regular")
                .controlSize(.regular)
            MyControls(label: "Large")
                .controlSize(.large)
            
            MyControls(label: "Outer: .regular")
                    .controlSize(.regular)
                    .overlay(
                        MyControls(label: "Inner: .mini")
                            .controlSize(.mini)
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                    )
        }
        .padding()
        .frame(width: 400)
        .border(Color.gray)
    }
}

struct MyControls: View {
    var label: String
    @State private var value = 3.0
    @State private var selected = 1
    var body: some View {
        HStack {
//            Text(label + ":")
            Picker("Selection", selection: $selected) {
                Text("option 1").tag(1)
                Text("option 2").tag(2)
                Text("option 3").tag(3)
            }
            Slider(value: $value, in: 1...10)
            Button("OK") {}
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
}

struct ContentView: View {
    // フォーカス状態を管理する列挙型を用意する
    enum Field: Hashable {
        case firstField
        case secondField
        case thirdField
    }

    // TextFieldの中身
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""

    // フォーカス状態を保持
    @FocusState private var focusedField: Field?

    var body: some View {
        ContentView2()
        ImmersiveView()
        ConfirmEraseItems()
        VStack(spacing: 20) {
            TextField("First Field", text: $text1)
                .focused($focusedField, equals: .firstField)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    focusedField = .secondField
                }

            TextField("Second Field", text: $text2)
                .focused($focusedField, equals: .secondField)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    focusedField = .thirdField
                }
            
            TextField("Third Field", text: $text3)
                .focused($focusedField, equals: .thirdField)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    focusedField = nil
                }
            
            HStack {
                Button("Focus First") {
                    focusedField = .firstField
                }
                Button("Focus Second") {
                    focusedField = .secondField
                }
                Button("Focus Third") {
                    focusedField = .thirdField
                }
                Button("Dismiss") {
                    focusedField = nil
                }
            }
        }
        .padding()
        // 最初に secondField にフォーカスを当てる
        .onAppear {
            focusedField = .secondField
        }
    }
}

struct ImmersiveView: View {
    var body: some View {
        Text("Maximum immersion")
            .persistentSystemOverlays(.hidden)
    }
}

struct ConfirmEraseItems: View {
    @State private var isShowingSheet = false
    var body: some View {
        Button("Show Action Sheet", action: {
            isShowingSheet = true
        })
        .actionSheet(isPresented: $isShowingSheet) {
            ActionSheet(
                title: Text("Permanently erase the items in the Trash?"),
                message: Text("You can't undo this action."),
                buttons:[
                    .destructive(Text("Empty Trash"),
                                 action: emptyTrashAction),
                    .cancel()
                ]
            )}
    }

    func emptyTrashAction() {
        // Handle empty trash action.
    }
}


struct ContentView2: View {
    @State private var showSettings = false

    var body: some View {
        Button("View Settings") {
            showSettings = true
        }
        .sheet(isPresented: $showSettings) {
            ContentView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct ContentView3: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ScreenIconsAndText()) {
                    Text("IconsAndText")
                }
                NavigationLink(destination: ScreenStraight()) {
                    Text("Straight")
                }
                NavigationLink(destination: ScreenCircle()) {
                    Text("Circle")
                }
            }
        }
    }
}
