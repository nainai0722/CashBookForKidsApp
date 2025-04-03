//
//  BubbleView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/09.
//

import SwiftUI

struct BubbleView: View {
    var text: String

    var body: some View {
        Text(text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                Triangle()
                    .fill(Color.white)
                    .frame(width: 20, height: 10)
                    .scaleEffect(y: -1)
                    .offset(y: 10),
                alignment: .bottom
            )
            .shadow(radius: 3)
    }
}

struct BubbleContentView<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .overlay(
                    Triangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 10)
                        .scaleEffect(y: -1)
                        .offset(y: 10),
                    alignment: .bottom
                )
                .shadow(radius: 3)

        }
    }
}



struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    BubbleView(text: "Hello")
    Spacer()
    BubbleContentView(content: {
        Image(systemName: "book")
    })
}

