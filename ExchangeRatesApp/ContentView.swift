//
//  ContentView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/6/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let extractedExpr: Text = Text("Hello, World!")
    var body: some View {
        NavigationView {
            List(everyDayRates) { dayRateModel in
                ARCurrencyRow(rateModel: dayRateModel)
            }
            .navigationBarTitle(Text("Landmarks"))
        }
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
