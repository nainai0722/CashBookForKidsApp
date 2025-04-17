//
//  SettingView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/12.
//

import SwiftUI
import RealmSwift
import FloatingButton

struct SettingView: View {
    @ObservedResults(User.self) var users
    @State private var path = NavigationPath()
    @State var isAddUserView: Bool = false
    var body: some View {
        NavigationStack {
            Text("ユーザー情報を変更する")
            
            ZStack(alignment: .bottomTrailing) {
                List(users) { user in
                    NavigationLink {
                        EditUserView(user: user, userData: castUserData(user))
                    } label: {
                        Text(user.name)
                    }
                }
                .listStyle(.plain)

                UserAddButton(isAddUserView: $isAddUserView)
                    .padding(.bottom, 20)
                    .padding(.trailing, 20)
            }

            NavigationLink(
                        destination: AddUserView(),
                        isActive: $isAddUserView,
                        label: { EmptyView() }
                    )
            
        }
    }
    
    func castUserData(_ user: User) -> UserData {
        return UserData(id: user.id, name: user.name, createdAt: user.createdAt, updatedAt: user.updatedAt)
        
    }
}
#Preview {
    SettingView()
}

struct UserAddButton: View {
    @State var isOpen = false
    @Binding var isAddUserView: Bool
    var body: some View {
        let mainButton2 = MainButton(imageName: "plus", colorHex: "eb3b5a", width: 60)

        let textButtons = MockData.iconAndTextTitles.enumerated().map { index, value in
            IconAndTextButton(
                imageName: MockData.iconAndTextImageNames[index],
                buttonText: value,
                action: {
                    handleButtonTap(index: index)
                }
            )
        }

        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: textButtons)
            .straight()
            .direction(.top)
            .alignment(.right)
            .spacing(10)
            .initialOpacity(0)

        return menu2
    }

    func handleButtonTap(index: Int) {
        switch index {
        case 0:
            isAddUserView.toggle()
            print("💡 ボタン0が押された！何かの登録処理など")
        case 1:
            print("📨 ボタン1が押された！メッセージ送信？")
        case 2:
            print("🔔 ボタン2が押された！通知を出す？")
        default:
            print("🤷‍♀️ 未定義のボタンが押された")
        }
        isOpen.toggle()
    }
}


struct ScreenIconsAndText: View {

    @State var isOpen = false

    var body: some View {
        let mainButton1 = MainButton(imageName: "star.fill", colorHex: "f7b731", width: 60)
        let mainButton2 = MainButton(imageName: "heart.fill", colorHex: "eb3b5a", width: 60)
        let textButtons = MockData.iconAndTextTitles.enumerated().map { index, value in
            IconAndTextButton(
                imageName: MockData.iconAndTextImageNames[index],
                buttonText: value,
                action: {
                  // ここに好きな処理を書く！
                  print("タップされたのは \(value)")
                  isOpen.toggle()
              })
                .onTapGesture { isOpen.toggle() }
        }

        let menu1 = FloatingButton(mainButtonView: mainButton1, buttons: textButtons, isOpen: $isOpen)
            .straight()
            .direction(.top)
            .alignment(.left)
            .spacing(10)
            .initialOffset(x: -1000)
            .animation(.spring())

        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: textButtons)
            .straight()
            .direction(.top)
            .alignment(.right)
            .spacing(10)
            .initialOpacity(0)

        return VStack {
                HStack {
                    menu1
                    Spacer()
                    menu2
                }
            }
            .padding(20)
    }
}

struct ScreenStraight: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        let mainButton1 = MainButton(imageName: "thermometer", colorHex: "f7b731")
        let mainButton2 = MainButton(imageName: "cloud.fill", colorHex: "eb3b5a")
        let buttonsImage = MockData.iconImageNames.enumerated().map { index, value in
            IconButton(imageName: value, action: {
                
            },
                       color: MockData.colors[index])
        }

        let menu1 = FloatingButton(mainButtonView: mainButton1, buttons: buttonsImage)
            .straight()
            .direction(.right)
            .delays(delayDelta: 0.1)

        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: buttonsImage)
            .straight()
            .direction(.top)
            .delays(delayDelta: 0.1)

        return VStack {
            Spacer()
            HStack {
                menu1
                Spacer()
                menu2
            }
            .padding(20)
        }
    }
}

struct ScreenCircle: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        let mainButton1 = MainButton(imageName: "message.fill", colorHex: "f7b731")
        let mainButton2 = MainButton(imageName: "umbrella.fill", colorHex: "eb3b5a")
        let mainButton3 = MainButton(imageName: "message.fill", colorHex: "f7b731")
        let buttonsImage = MockData.iconImageNames.enumerated().map { index, value in
            IconButton(imageName: value, action: {}, color: MockData.colors[index])
        }

        let menu1 = FloatingButton(mainButtonView: mainButton2, buttons: buttonsImage.dropLast())
            .circle()
            .startAngle(3/2 * .pi)
            .endAngle(2 * .pi)
            .radius(70)
        let menu2 = FloatingButton(mainButtonView: mainButton1, buttons: buttonsImage)
            .circle()
            .delays(delayDelta: 0.1)
        let menu3 = FloatingButton(mainButtonView: mainButton3, buttons: buttonsImage.dropLast())
            .circle()
            .layoutDirection(.counterClockwise)
            .startAngle(3/2 * .pi)
            .endAngle(2 * .pi)
            .radius(70)

        return VStack {
            Spacer()
            HStack {
                menu1
                Spacer()
                menu2
                Spacer()
                menu3
            }
            .padding(20)
        }
    }
}

struct MainButton: View {

    var imageName: String
    var colorHex: String
    var width: CGFloat = 50

    var body: some View {
        ZStack {
            Color(hex: colorHex)
                .frame(width: width, height: width)
                .cornerRadius(width / 2)
                .shadow(color: Color(hex: colorHex).opacity(0.3), radius: 15, x: 0, y: 15)
            Image(systemName: imageName)
                .foregroundColor(.white)
        }
    }
}

struct IconButton: View {

    var imageName: String
    var action: () -> Void
    var color: Color
    let imageWidth: CGFloat = 20
    let buttonWidth: CGFloat = 45

    var body: some View {
        ZStack {
            color
            Image(systemName: imageName)
                .frame(width: imageWidth, height: imageWidth)
                .foregroundColor(.white)
        }
        .frame(width: buttonWidth, height: buttonWidth)
        .cornerRadius(buttonWidth / 2)
        .onTapGesture {
            action()
        }
    }
}

struct IconAndTextButton: View {

    var imageName: String
    var buttonText: String
    var action: () -> Void
    let imageWidth: CGFloat = 22

    var body: some View {
        ZStack {
            Color.white
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .foregroundColor(Color(hex: "778ca3"))
                    .frame(width: imageWidth, height: imageWidth)
                    .clipped()
                Spacer()
                Text(buttonText)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(Color(hex: "4b6584"))
                Spacer()
            }
            .padding(.horizontal, 15)
        }
        .frame(width: 160, height: 45)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "F4F4F4"), lineWidth: 1)
        )
        .onTapGesture {
            action()
        }
    }
}

struct MockData {

    static let colors = [
        "e84393",
        "0984e3",
        "6c5ce7",
        "00b894"
    ].map { Color(hex: $0) }

    static let iconImageNames = [
        "sun.max.fill",
        "cloud.fill",
        "cloud.rain.fill",
        "cloud.snow.fill"
    ]

    static let iconAndTextImageNames = [
        "plus.circle.fill",
        "minus.circle.fill",
        "pencil.circle.fill"
    ]

    static let iconAndTextTitles = [
        "Add New",
        "Remove",
        "Rename"
    ]
}

extension Color {

    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif


#Preview {
    SettingView()
}

struct EditUserView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedRealmObject var user: User
    @State var userData: UserData
    @State private var showAlert = false
    var body: some View {
        VStack {
            Text(user.name)
            TextField("名前を入力", text: $userData.name)
                .textFieldStyle(.roundedBorder)
                .textCase(.lowercase)
                .multilineTextAlignment(.trailing)
            Button("更新") {
                updateUser(user)
                dismiss()
            }
            Button("削除") {
                showAlert = true
            }
            .alert("ユーザーを削除しますか？", isPresented: $showAlert) {
                Button("削除", role: .destructive) {
                    deleteUser(user)
                    dismiss()
                }
                Button("キャンセル", role: .cancel) {}
            }
        }
    }

    func updateUser(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToUpdate = users.filter { $0.id == user.id }.first!
        
        try! realm.write {
            userToUpdate.name = userData.name
        }
    }
    
    func deleteUser(_ user: User) {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        let userToDelete = users.filter {$0.id == user.id }.first!
        
        try! realm.write {
            realm.delete(userToDelete)
        }
    }
}

struct AddUserView: View {
    @Environment(\.dismiss) var dismiss
    @State var newUSerName: String = ""
    var body: some View {
        VStack {
            Text("新規ユーザー")
            TextField("名前を入力", text: $newUSerName)
                .textFieldStyle(.roundedBorder)
                .textCase(.lowercase)
                .multilineTextAlignment(.trailing)
            Button("追加") {
                addUser(newUSerName)
                dismiss()
            }
        }
    }
    func addUser(_ name: String) {
        let realm = try! Realm()
        
        // すでに同じ名前のユーザーがいるかチェック
        if realm.objects(User.self).filter("name == %@", name).first != nil {
            print("同じ名前のユーザーが存在します。追加をキャンセルします。")
            return
        }
        
        let child = User()
        child.name = name
        
        try! realm.write {
            
            
            realm.add(child)
            print(child.id)
        }
        saveUserIds(child.id)
    }
    
    func saveUserIds(_ ids: String) {
        var savedUserIds = loadUserIds()
        savedUserIds.append(ids)
        UserDefaults.standard.set(savedUserIds, forKey: "savedUserIds")
    }
    
    func loadUserIds() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "savedUserIds") ?? []
    }
}


#Preview {
    EditUserView(user: User(), userData: UserData(id: "111", name: "ユーザー変更", createdAt: Date(), updatedAt: Date()))
}
