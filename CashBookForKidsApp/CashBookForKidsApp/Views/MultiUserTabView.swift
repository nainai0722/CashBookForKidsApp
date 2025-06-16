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
    @State var isShowInsertView: Bool = true
    @ObservedResults(User.self) var users
    
    // ダークモード判定
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                let _ = print("ダークモード")
            }
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
                            Text("settings".localized)
                        }
                }
                .fullScreenCover(isPresented: $isShowFullScreen) {
                    RealmControl()
                }
            }
            // ボタンを設置した・・・
//            ScreenStraight2()
        }
        .onAppear {
            isShowFullScreen = users.isEmpty ? true : false
        }
        .background(colorScheme == .dark ? .white: Color.white)
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

extension Date_Extensions {
    static var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    static var today: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())!
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
    @State private var showTitle: Bool = false
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
                Text("add".localized)
                    .modifier(CustomGreenButton(fontType: .headline))
            }
            .offset(x: showTitle ? 0 : -UIScreen.main.bounds.width)
            .animation(.easeOut(duration: 1.0), value: showTitle)
            .onAppear {
                showTitle = true
            }
            
            Button(action: {
                editMoney = nil
                isShowingExpenseSheet.toggle()
            }){
                Text("remove".localized)
                    .modifier(CustomGreenButton(fontType: .headline))
            }
            .offset(y: showTitle ? 0 : -UIScreen.main.bounds.height)
            .animation(.easeOut(duration: 1.0), value: showTitle)
            .onAppear {
                showTitle = true
            }
            
            Button(action: {
                editMoney = nil
                isShowingTaraRevaCalculateSheet.toggle()
            }){
                Text("what_if_calculator".localized)
                    .modifier(CustomGreenButton(fontType: .headline))
            }
            .offset(x: showTitle ? 0 : UIScreen.main.bounds.width)
            .animation(.easeOut(duration: 1.0), value: showTitle)
            .onAppear {
                showTitle = true
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
                Text("favorites".localized)
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
