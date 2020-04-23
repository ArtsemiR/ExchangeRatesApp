//
//  ARCurrencyRow.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/15/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARCurrencyRow: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var rateModel: ARDayRateModel
    var isNeedRightArrow = false
    var isNeedCurrency: Bool = false

    // MARK: - gui

    private var flag: Text {
        Text(ARRate.s.getFlag(rateModel.Cur_Abbreviation))
            .font(.largeTitle)
    }

    private var currencyCode: Text {
        Text(self.rateModel.Cur_Abbreviation)
            .fontWeight(.semibold)
    }

    private var currencyName: Text {
        Text("\(self.rateModel.Cur_Scale) \(self.rateModel.Cur_Name)")
            .font(.footnote)
            .fontWeight(.thin)
    }

    private var officialRate: Text {
        Text("\(rateModel.Cur_OfficialRate.toAmountString) \(self.isNeedCurrency ? "BYN" : "")")
            .fontWeight(.semibold)
    }

    // MARK: - Body

    var body: some View {
        HStack {
            self.flag
                .offset(x: 0, y: -8)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        self.currencyCode
                            .accentColor(self.colorScheme == .light ? .black : .white)
                        self.currencyName
                            .accentColor(self.colorScheme == .light ? .black : .white)
                    }
                    Spacer()
                    self.officialRate
                        .accentColor(self.colorScheme == .light ? .black : .white)
                    if self.isNeedRightArrow {
                        Image(systemName: "chevron.right")
                        .accentColor(.gray)
                    }
                }
                Divider()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
    }
}

// MARK: - Preview

struct ARCurrencyRow_Previews: PreviewProvider {
    static var previews: some View {
        ARCurrencyRow(rateModel: everyDayRates.first!)
    }
}
