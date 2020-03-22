//
//  ARChartPeriodView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/22/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARPeriodView: View {
    let text: String
    let isChecked: Bool

    private var dividerColor: Color {
        return self.isChecked ? .red : .gray
    }
    
    var body: some View {
        Text(self.text)
        .fontWeight(.thin)
        .frame(alignment: .center)
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(self.dividerColor, lineWidth: 1)
                .frame(height: 24)
        )
    }
}

struct ARChartPeriodView: View {

    @Binding var periodSelection: Int

    private var month: ARPeriodView {
        return ARPeriodView(text: "1 мес.",
                            isChecked: self.periodSelection == 0 ? true : false)
    }

    private var threeMonth: ARPeriodView {
        return ARPeriodView(text: "3 мес.",
                            isChecked: self.periodSelection == 1 ? true : false)
    }

    private var year: ARPeriodView {
        return ARPeriodView(text: "1 год",
                            isChecked: self.periodSelection == 2 ? true : false)
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                self.month
                .onTapGesture {
                    self.periodSelection = 0
                }
                self.threeMonth
                .onTapGesture {
                    self.periodSelection = 1
                }
                self.year
                .onTapGesture {
                    self.periodSelection = 2
                }
            }.frame(width: geometry.size.width - 16)
        }
    }
}
