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

    var body: some View {
        let extractedExpr: Text = Text(AMRate.s.getFlag(rateModel.Cur_Abbreviation))
        HStack(alignment: .center) {
            extractedExpr
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text(self.rateModel.Cur_Abbreviation)
                Text("\(self.rateModel.Cur_Scale) \(self.rateModel.Cur_Name)")
            }
            Spacer()

            VStack(alignment: .trailing) {
                Text("\(rateModel.Cur_OfficialRate)")
                Text("BYN")
            }
        }
    }
}

struct ARCurrencyRow_Previews: PreviewProvider {
    static var previews: some View {
        ARCurrencyRow(rateModel: everyDayRates.first!)
    }
}
