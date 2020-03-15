//
//  ARCurrencyStatsView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/10/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARCurrencyStatsView: View {

    @EnvironmentObject var yearRatesFetcher: ARYearRatesFetcher

    var body: some View {
        VStack {
            if !self.yearRatesFetcher.isLoading {
                ARChartSwiftUIView()
                    .environmentObject(yearRatesFetcher)
                    .frame(height: 250.0)
            }
        }
    }
}

struct ARCurrencyStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ARCurrencyStatsView()
    }
}
