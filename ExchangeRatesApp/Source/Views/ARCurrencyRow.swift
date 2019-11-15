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
        HStack {
            Text(rateModel.Cur_Name)
        }
    }
}

struct ARCurrencyRow_Previews: PreviewProvider {
    static var previews: some View {
        ARCurrencyRow(rateModel: everyDayRates[0])
    }
}
