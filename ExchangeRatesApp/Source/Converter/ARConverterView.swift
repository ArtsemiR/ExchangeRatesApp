//
//  ARConverterView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/29/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARConverterView: View {
    @EnvironmentObject var dayRates: ARDayRatesFetcher
    @EnvironmentObject var monthRates: ARMonthRatesFetcher

    @State private var changedRate: (code: String, amount: String) = (code: "BYN", amount: "1")

    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }

    // MARK: Body

    var body: some View {
        NavigationView {
            Group {
                if self.dayRates.isLoading || self.monthRates.isLoading {
                    ARActivityIndicatorView()
                        .scaleEffect(2)
                } else {
                    List {
                        BYNCurrencyConverterView(changedRate: self.$changedRate)
                            .frame(height: 60)
                        if !self.dayRates.rates.isEmpty {
                            ForEach(self.dayRates.rates,
                                    id: \.Cur_ID) { dayRate in
                                        CurrencyConverterView(rateModel: dayRate, changedRate: self.$changedRate)
                                        .frame(height: 60)
                            }
                        }

                        if !self.monthRates.rates.isEmpty {
                            ForEach(self.monthRates.rates,
                                    id: \.Cur_ID) { monthRate in
                                        CurrencyConverterView(rateModel: monthRate, changedRate: self.$changedRate)
                                            .frame(height: 60)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Конвертер")
        }
    }
}

struct ARConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ARConverterView()
    }
}
