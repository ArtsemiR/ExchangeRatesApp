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

    // MARK: - GUI

    fileprivate func title() -> Text {
        return Text(ARRate.s.getFlag(rateModel.Cur_Abbreviation))
            .font(.largeTitle)
    }

    fileprivate func currencyCode() -> Text {
        return Text(self.rateModel.Cur_Abbreviation)
    }

    fileprivate func currencyName() -> Text {
        return Text("\(self.rateModel.Cur_Scale) \(self.rateModel.Cur_Name)")
    }

    // MARK: - Body

    fileprivate func officialRate() -> Text {
        return Text("\(rateModel.Cur_OfficialRate.toAmountString)")
    }

    var body: some View {
        HStack(alignment: .center) {
            self.title()

            VStack(alignment: .leading) {
                self.currencyCode()
                self.currencyName()
            }
            Spacer()

            VStack(alignment: .trailing) {
                self.officialRate()
                Text("BYN")
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
