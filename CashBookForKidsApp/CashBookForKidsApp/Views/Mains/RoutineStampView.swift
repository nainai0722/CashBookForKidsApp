//
//  RoutineStampView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import SwiftUI
import SwiftData

struct RoutineStampView: View {
    @Binding var routines: [Routine]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach($routines, id: \.self) { routine in
                            StampCellView(routine: routine)
                        }
                    }
                }
                Spacer()

            }
        }
    }
}

#Preview {
    RoutineStampView(routines: .constant(Routine.mockMorningRoutines))
}

struct DoneTypeBStampView: View {
    var size :CGFloat = 90
    var fontSize: CGFloat = 30
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.85))
                    .frame(width: size, height: size) // サイズを指定
                Text("OK")
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(-40))
                    .font(.system(size: fontSize))

            }
            
        }
    }
}

struct DoneTypeAStampView: View {
    var size :CGFloat = 90
    var fontSize: CGFloat = 30
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.85))
                    .frame(width: size, height: size) // サイズを指定
                VStack {
                    Text("でき")
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(-40))
                        .font(.system(size: fontSize))
                        .offset(x:-20, y:10)
                    Text("たね")
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(-40))
                        .font(.system(size: fontSize))
                        .offset(x:0, y:-20)
                }
            }
        }
    }
}


struct StampCellView: View {
    @Binding var routine: Routine
    var size = ( UIScreen.main.bounds.width / 3 ) - 50
    var stampViews :[AnyView] = [AnyView(DoneTypeAStampView()),AnyView(DoneTypeBStampView())]
    @State private var selectedStamp: AnyView?
    var body: some View {
        Button(action:{
            routine.done.toggle()
            selectedStamp = stampViews.randomElement()
        }){
            ZStack {
                VStack {
                    Image(routine.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width:size , height:size )
                        .padding()
                }
                .background()
                .cornerRadius(8)
                .shadow(radius: 10)
                .overlay(content: {
                    VStack {
                        selectedStamp
                    }
                    .opacity(routine.done ? 1 : 0)
                })
            }
            .padding()
        }
    }
}
