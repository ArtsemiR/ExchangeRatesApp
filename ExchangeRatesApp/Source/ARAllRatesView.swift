//
//  ARAllRatesView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/15/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARAllRatesView: View {
    @ObservedObject var ratesFetcher = ARDayRatesFetcher()
    
    var body: some View {
        NavigationView {
            List(ratesFetcher.rates, id: \.Cur_ID) { dayRateModel in
                ARCurrencyRow(rateModel: dayRateModel)
            }
            .navigationBarTitle(Text("Валюты"))
        }
    }
}

struct AllRatesView_Previews: PreviewProvider {
    static var previews: some View {
        ARAllRatesView()
    }
}
