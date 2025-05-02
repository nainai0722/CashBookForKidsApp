//
//  MailLinkView.swift
//  CashBookForKidsApp
//
//  Created by 指原奈々 on 2025/05/01.
//

import SwiftUI

struct MailLinkView: View {
    var body: some View {
        Link("メール送信",
              destination: URL(string: "mailto:campsisgrandiflora0722@gmail.com")!)
    }
}

#Preview {
    MailLinkView()
}
