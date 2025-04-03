//
//  CustomLayout.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/09.
//

import SwiftUI

struct CustomLayout: View {
    var body: some View {
        Button(action:{}){
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 70)
        }
        .modifier(CustomButtonLayout())
        
        Text("色を変える")
            .modifier(CustomButtonLayoutWithSetColor(textColor: Color.white,backGroundColor: Color.green,fontType: .largeTitle))
    }
}
#Preview {
    CustomLayout()
}

struct CustomButtonLayout:ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 70)
            .buttonStyle(.borderedProminent)
            .tint(Color.blue)
            .foregroundColor(.white)
            .font(.title)
            .cornerRadius(15)
            .shadow(radius: 5) // 影をつける
            .padding()
    }
}

struct CustomButtonLayoutWithSetColor:ViewModifier {
    var textColor: Color
    var backGroundColor: Color
    var fontType: Font
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 70)
            .background(backGroundColor)
            .foregroundColor(textColor)
            .font(fontType)
            .cornerRadius(15)
            .shadow(radius: 5) // 影をつける
            .padding()
    }
}

#Preview {
    CustomLayout()
}
