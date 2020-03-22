//
//  ARCurrencyRow.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/15/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARCurrencyRow: View {

    var rateModel: ARDayRateModel
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
            VStack(alignment: .leading) {
                self.currencyCode
                self.currencyName
            }
            Spacer()

            VStack(alignment: .trailing) {
                self.officialRate
            }
        }
    }
}

// MARK: - Preview

struct ARCurrencyRow_Previews: PreviewProvider {
    static var previews: some View {
        ARCurrencyRow(rateModel: everyDayRates.first!)
    }
}
