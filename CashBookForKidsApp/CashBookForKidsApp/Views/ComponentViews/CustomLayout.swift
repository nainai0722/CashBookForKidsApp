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
        
        Button(action: {
            
        }){
            Text("変更")
                .modifier(CustomColorFontSizeButton(fontSize: 15, color: .blue))
        }
        
        Button(action:{}){
            Text("ふやす")
                .modifier(CustomGreenButton(fontType: .headline))
        }
        
        
        Text("色を変える")
            .modifier(CustomButtonLayoutWithSetColor(textColor: Color.white,backGroundColor: Color.green,fontType: .largeTitle))
        
        Text("Paypayっぽく")
            .modifier(CustomButtonWithColorFont(textColor: .white, backGroundColor: .blue, fontSize: 20))
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
//            .shadow(radius: 5) // 影をつける
            .padding()
    }
}

struct CustomButtonWithColorFont:ViewModifier {
    var textColor: Color
    var backGroundColor: Color
    var fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .background(backGroundColor)
            .foregroundColor(textColor)
            .fontWeight(.bold)
            .font(.system(size: fontSize))
            .cornerRadius(6)
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
            .padding()
    }
}

struct CustomGreenButton:ViewModifier {
    var fontType: Font
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 35)
            .background(.green)
            .foregroundColor(.white)
            .font(fontType)
            .cornerRadius(7)
            .padding()
    }
}

struct CustomColorFontSizeButton:ViewModifier {
    var fontSize: CGFloat
    var color: Color
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(color)
            .foregroundColor(.white)
            .font(.system(size: fontSize))
            .cornerRadius(7)
            .padding()
    }
}

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    CustomLayout()
}
