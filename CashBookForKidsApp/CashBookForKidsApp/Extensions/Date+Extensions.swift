//
//  Date+Extensions.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI

struct Date_Extensions: View {
    var body: some View {
        let nowTimeString = Date().formattedString
        Text(nowTimeString)
        Text(Date().formattedMonthDayString_JP)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM dd HH:mm"
        return formatter.string(from: self)
    }
    var formattedYearMonthDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM dd"
        return formatter.string(from: self)
    }
    var formattedMonthDayString_JP: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月dd日"
        return formatter.string(from: self)
    }
    var formattedMonthDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: self)
    }
    
    var weekString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

extension String {
    func localized(with arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, arguments: arguments)
    }
}

#Preview {
    Date_Extensions()
}
