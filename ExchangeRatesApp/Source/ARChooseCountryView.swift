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

    @State var filtered: [ARDayRateModel] = []

    // MARK: - Body

    var body: some View {
        NavigationView {
            List(filtered, id: \.Cur_ID) { rate in
               ARConverterCurrencyView(rateModel: rate,
                                       isShowing: Defaults.shared.countryCodes.contains(rate.Cur_ID))
            }.id(UUID())
            .onAppear {
                self.filterRates()
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

    fileprivate func filterRates() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30)) {
            var arr = self.dayRates.rates
            arr.append(contentsOf: self.monthRates.rates)
            self.filtered = arr
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
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                VStack(alignment: .leading) {
                    self.currencyCode
                    self.currencyName
                }
            }
        }.onTapGesture {
            if self.isShowing {
                Defaults.shared.removeCountryCode(self.rateModel.Cur_ID)
            } else {
                Defaults.shared.addCountryCode(self.rateModel.Cur_ID)
            }
        }
    }
}
