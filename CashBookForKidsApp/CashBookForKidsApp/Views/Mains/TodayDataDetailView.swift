//
//  TodayDataDetailView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/15.
//

import SwiftUI
import SwiftData

struct TodayDataDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTodayData: TodayData
    @State var isPresented: Bool = false
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            Text("\(selectedTodayData.timestamp.formattedMonthDayString_JP)のこまかい情報")
                .font(.headline)
            Text(selectedTodayData.timestamp.formattedString)
                .font(.footnote)
            Divider()
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing:0) {
//                    let morningRoutines = selectedTodayData.routineTitles.filter { $0.name == "あさのしたく" }.first!.routines
                    ForEach(selectedTodayData.routineTitles.filter { $0.name == "あさのしたく" }.first!.routines, id: \.id) { routine in
                        StampMiniCellView(routine: routine)
                    }
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing:0) {
                    let sleepTimeRoutines = selectedTodayData.routineTitles.filter { $0.name == "ねるまえのしたく" }.first!.routines
                    ForEach(sleepTimeRoutines, id: \.id) { routine in
                        StampMiniCellView(routine: routine)
                    }
                }
            }
            
            BubbleView(text: "今日は\(selectedTodayData.bookCount)冊読んだ")
            HStack {
                ForEach(1...5, id: \.self) { count in
                    if count <= selectedTodayData.bookCount {
                        Button(action:{
                            selectedTodayData.bookCount = selectedTodayData.bookCount - 1
                        }){
                            Image(systemName: "book.fill")
                                .font(.system(size: 30))
                        }
                            
                    } else {
                        Button(action:{
                            selectedTodayData.bookCount = selectedTodayData.bookCount + 1
                        }){
                            Image(systemName: "book")
                                .font(.system(size: 30))
                        }
                            
                    }
                }
            }
            .padding()
            
            ZStack {
                BubbleContentView(){
                    HStack {
                        Button(action:{
                            isPresented = false
                            selectedTodayData.moodType = .happy
//                            saveData()
                        }){
                            Text("うれしい")
                        }
                        Button(action:{
                            isPresented = false
                            selectedTodayData.moodType = .sad
//                            saveData()
                        }){
                            Text("つかれた")
                        }
                        Button(action:{
                            isPresented = false
                            selectedTodayData.moodType = .neutral
//                            saveData()
                        }){
                            Text("ふだんどおり")
                        }
                    }
                }
                .offset(y: -50)
                .opacity(isPresented ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isPresented)

                
                Button(action:{
                    isPresented.toggle()
                }){
                    MoodTypeView(selectedTodayData:$selectedTodayData)
                    
                }
                
                
            }
            
//            Text("幼稚園は\(selectedTodayData.kindergartenCalendarType!.rawValue)")
            
            Image("medalist_woman_color")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .opacity(selectedTodayData.kindergartenCalendarType == .gone ? 1 : 0)
            
            Image("shopping_supermarket_family_father")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .opacity(selectedTodayData.kindergartenCalendarType == .holiday ? 1 : 0)
            
//            Spacer()
            
        }
        .padding() // 余白をつける
    }
    
    
    
    private func saveData() {
           do {
               try modelContext.save()
           } catch {
               print("データの保存に失敗: \(error)")
           }
       }
    
}

struct StampMiniCellView: View {
    var routine: Routine
    var size: CGFloat = 30
    @State private var selectedStamp: AnyView?
    var body: some View {
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
                    DoneTypeBStampView(size: 45, fontSize: 20)
                }
                .opacity(routine.done ? 1 : 0)
            })
        }
        .padding()
    }
}

#Preview {
    TodayDataDetailView(selectedTodayData: .constant(TodayData()), isPresented: false)
}

struct MoodTypeView: View {
    @Binding var selectedTodayData: TodayData
    var body: some View {
        VStack{
            Image(imageName())
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
    
    func imageName() -> String {
        switch selectedTodayData.moodType {
        case .happy:
            return "mark_face_laugh"
        case .sad:
            return "mark_face_cry"
        case .neutral:
            return "mark_face_tere"
        case .none:
            return "mark_face_smile"
        }
    }
}
