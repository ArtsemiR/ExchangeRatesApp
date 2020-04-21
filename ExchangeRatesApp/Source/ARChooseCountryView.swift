//
//  ARChooseCountryView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 4/21/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARChooseCountryView: View {

    @EnvironmentObject var dayRates: ARDayRatesFetcher
    @EnvironmentObject var monthRates: ARMonthRatesFetcher

    @Binding var showSheetView: Bool

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                if !self.dayRates.rates.isEmpty {
                    ForEach(self.dayRates.rates,
                            id: \.Cur_ID) { dayRate in
                                ARConverterCurrencyView(rateModel: dayRate,
                                                        isShowing: Defaults.countryCodes().contains(dayRate.Cur_ID))
                                    .frame(height: 60)
                    }
                }

                if !self.monthRates.rates.isEmpty {
                    ForEach(self.monthRates.rates,
                            id: \.Cur_ID) { monthRate in
                                ARConverterCurrencyView(rateModel: monthRate,
                                                        isShowing: Defaults.countryCodes().contains(monthRate.Cur_ID))
                                    .frame(height: 60)
                    }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showSheetView = false
                }, label: {
                    Text("Сохранить").bold()
                })
            )
        }
    }
}

struct ARConverterCurrencyView: View {

    var rateModel: ARDayRateModel
    @State var isShowing: Bool

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

    // MARK: - Body

    var body: some View {
        Toggle(isOn: $isShowing) {
            HStack {
                self.flag
                VStack(alignment: .leading) {
                    self.currencyCode
                    self.currencyName
                }
            }
        }.onTapGesture {
            if self.isShowing {
                Defaults.removeCountryCode(self.rateModel.Cur_ID)
            } else {
                Defaults.addCountryCode(self.rateModel.Cur_ID)
            }
        }
    }
}
