//
//  SymbolsAnimationView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/04/25.
//

import SwiftUI

struct Interactful: App {
    var body: some Scene {
        WindowGroup("Window Group", id: "windowgroup") {
            EmptyView()
        }
    }
}

struct WindowGroupView: View {
    @Environment(\.openWindow) var openWindow

    var body: some View {
        Button(action: {
            openWindow(id: "windowgroup")
        }) {
            Text("Open Window Group")
        }
    }
}

struct ProgressAnimationView:View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var progress: Double = 0.0
    var body: some View {
        ProgressView(value: progress, total: 100,
            label: {
                Text("Downloading...")
                    .padding(.bottom, 4)
            }, currentValueLabel: {
                Text("\(Int(progress))%")
                    .padding(.top, 4)
            }
        ).progressViewStyle(.linear)
        .onReceive(timer) { _ in
            if progress < 100 {
                progress += 1
            } else {
                progress = 0
            }
        }
    }
}

struct SymbolsAnimationView: View {
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    @State private var text2 = "Tap, touch and hold, or swipe left to rename"
    let minValue = 0.0
    let maxValue = 75.0
    let current: Double = 50.0
    
    private var uploadProgress: Double = 0.5
    
    
    var body: some View {
        
        ViewThatFits(in: .horizontal) {
            HStack {
                Text("\(uploadProgress.formatted(.percent))")
                ProgressView(value: uploadProgress)
                    .frame(width: 100)
                Spacer()
            }
            
            ProgressView(value: uploadProgress)
                .frame(width: 100)
            
            HStack {
                Text("\(uploadProgress.formatted(.percent))")
                Spacer()
            }
        }
        
        
        if #available(iOS 17.0, *) {
            ContentUnavailableView.search
        } else {
            // Fallback on earlier versions
        }
        
        Gauge(value: current, in: minValue...maxValue) {
            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
        } currentValueLabel: {
            Text("(Int(current))")
                .foregroundStyle(Color.green)
        } minimumValueLabel: {
            Text("(Int(minValue))")
                .foregroundStyle(Color.green)
        } maximumValueLabel: {
            Text("(Int(maxValue))")
                .foregroundStyle(Color.red)
        }.gaugeStyle(.accessoryCircular)
        
        // リンク
        Link("apple.com",
            destination: URL(string: "https://www.apple.com")!)
        // 共有
        ShareLink(item: URL(string: "https://apps.apple.com/app/id1528095640")!)
        ShareLink(item: "Hello, World!")
        
        PasteButton(payloadType: String.self) { strings in
            text = strings[0]
        }.labelStyle(.titleOnly)
        
        // リネームボタン
        TextField(text: $text2) {
            Text("Tap, touch and hold, or swipe left to rename")
        }.focused($isFocused)
        
        RenameButton()
            .swipeActions(edge: .trailing) {
                RenameButton()
            }.contextMenu {
                RenameButton()
            }.renameAction {
                isFocused = true
            }
        
        if #available(iOS 18.0, *) {
            Image(systemName: "waveform.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.blue)
                .symbolRenderingMode(.monochrome)
                .symbolVariant(.none)
                .fontWeight(.regular)
//                .symbolEffect(.wiggle)
            
            Image(systemName: "checkmark.bubble.fill")
                .font(.system(size: 40))
                .foregroundStyle(.blue)
                .symbolRenderingMode(.hierarchical)
                .symbolVariant(.none)
                .fontWeight(.regular)
//                .symbolEffect(.wiggle)
            
        } else {
            // Fallback on earlier versions
        }
    }
}

var body: some Scene {
    WindowGroup {
        ContentView()
    }.commands {
        AppCommands()
    }
}

struct AppCommands: Commands {
    @CommandsBuilder var body: some Commands {
        CommandMenu("Command Menu", content: {
            Button("Show Documentation") {
            
            }.keyboardShortcut("D", modifiers: .control)
            
            Button("Show Snippet") {
            
            }.keyboardShortcut("C", modifiers: .control)
        })
    }
}

#Preview {
    SymbolsAnimationView()
//    WindowGroupView()
}
