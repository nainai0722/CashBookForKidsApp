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
            Text("change".localized)
                .modifier(CustomColorFontSizeButton(fontSize: 15, color: .blue))
        }
        
        Button(action:{}){
            Text("add".localized)
                .modifier(CustomGreenButton(fontType: .headline))
        }
        
        
        Text("change_color".localized)
            .modifier(CustomButtonLayoutWithSetColor(textColor: Color.white,backGroundColor: Color.green,fontType: .largeTitle))
        
        Text("look_like_paypay")
            .modifier(CustomButtonWithColorFont(textColor: .white, backGroundColor: .blue, fontSize: 20))
    }
}
#Preview {
    CustomLayout()
}

struct WiggleView: ViewModifier {
    var wiggle: Bool
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(wiggle ? 2 : -2))
            .animation(wiggle ? .easeInOut(duration: 0.1).repeatForever(autoreverses: true) : .default, value: wiggle)
    }
}

struct CustomGreen: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.dynamic(light: .green, dark: .green.opacity(0.4)))
    }
}

struct CustomBackGroundGreen: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.dynamic(light: .green, dark: .green.opacity(0.4)))
    }
}


/*
 .rotation3DEffect(
     .degrees(isWiggle ? 36 : 0),
     axis: (x: 0, y: 1, z: 0)
 )
 */

struct BorderedTextChangeColor: ViewModifier {
    var isSelected: Bool
    func body(content: Content) -> some View {
        content
            .padding(10) // テキストの周りに余白を追加
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? Color.blue : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(isSelected ? Color.white : Color.blue, lineWidth: 2)
                    )
            )
    }
}

struct BorderedTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.blue, lineWidth: 2) // 枠線を追加
                    )
            )
    }
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
            .customBackGroundGreen()
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
    func wiggle(wiggle: Bool) -> some View {
        self.modifier(WiggleView(wiggle: wiggle))
    }
    
    func customGreen() -> some View {
        self.modifier(CustomGreen())
    }
    
    func customBackGroundGreen() -> some View {
        self.modifier(CustomBackGroundGreen())
    }
}

#Preview {
    CustomLayout()
}
