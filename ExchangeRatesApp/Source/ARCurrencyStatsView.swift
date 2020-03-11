//
//  ARCurrencyStatsView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/10/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARCurrencyStatsView: View {
    @ObservedObject var yearRatesFetcher = ARYearRatesFetcher("170")

    var body: some View {
        VStack(alignment: .leading) {
            
        }
    }
}

struct ARCurrencyStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ARCurrencyStatsView()
    }
}
