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

    @State private var changedRate: (code: String, amount: String) = (code: "BYN", amount: "0")
    @State var isModal: Bool = false
    @State var activeCurrency: String = "BYN"

    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }

    private var dayRatesList: [ARDayRateModel] {
        return self.dayRates.rates.filter { ARUserDefaultsManager.shared.countryCodes.contains($0.Cur_ID) }
    }
    private var monthRatesList: [ARDayRateModel] {
        return self.monthRates.rates.filter { ARUserDefaultsManager.shared.countryCodes.contains($0.Cur_ID) }
    }

    // MARK: Body
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    BYNCurrencyConverterView(changedRate: self.$changedRate,
                                             activeCurrency: self.$activeCurrency)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    if !self.dayRatesList.isEmpty {
                        ForEach(self.dayRatesList,
                                id: \.Cur_ID) { dayRate in
                                    CurrencyConverterView(rateModel: dayRate,
                                                          changedRate: self.$changedRate,
                                                          activeCurrency: self.$activeCurrency)
                                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        }
                    }

                    if !self.monthRatesList.isEmpty {
                        ForEach(self.monthRatesList,
                                id: \.Cur_ID) { monthRate in
                                    CurrencyConverterView(rateModel: monthRate,
                                                          changedRate: self.$changedRate,
                                                          activeCurrency: self.$activeCurrency)
                                        .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 0))
                        }
                    }
//                    GeometryReader { (geometry) in
//                        ARBannerView(adUnitID: "ca-app-pub-2699836089641813/9182668607",
//                                     width: geometry.size.width)
//                    }
//                    .frame(height: 50)
//                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                }
                .blur(radius: self.isModal ? 2 : 0)
            }.modifier(AdaptsToSoftwareKeyboard())
                .sheet(isPresented: $isModal, content: {
                ARChooseCountryView(showSheetView: self.$isModal)
                    .environmentObject(self.dayRates)
                    .environmentObject(self.monthRates)
            })
            .navigationBarTitle("Конвертер")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isModal = true
                }, label: {
                    Text("Изменить")
                        .bold()
                })
            )
        }
    }
}

struct ARConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ARConverterView()
    }
}
