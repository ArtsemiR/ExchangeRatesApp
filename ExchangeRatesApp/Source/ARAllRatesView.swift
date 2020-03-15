//
//  ARAllRatesView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/15/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARAllRatesView: View {

    @EnvironmentObject var dayRates: ARDayRatesFetcher
    @EnvironmentObject var monthRates: ARMonthRatesFetcher

    @State private var showCountryRate = false
    @State private var selectedCurrencyName = ""

    // MARK: - ui
    
    private func dayRateSectionHeader() -> Text {
        var date: String = ""
        if let resDate = self.dayRates.rates.first?.Date {
            date = "на \(resDate.formattedDate(format: .ddMMyyyy))"
        }
        return Text("\("Ежедневный курс") \(date)")
            .fontWeight(.thin)
    }

    private func monthRateSectionHeader() -> Text {
        var date: String = ""
        if let resDate = self.monthRates.rates.first?.Date {
            date = "на \(resDate.formattedDate(format: .ddMMyyyy))"
        }
        return Text("\("Ежемесячный курс") \(date)")
            .fontWeight(.thin)
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
                        if !self.dayRates.rates.isEmpty {
                            Section(header: self.dayRateSectionHeader()) {
                                ForEach(self.dayRates.rates,
                                        id: \.Cur_ID) { dayRate in
                                            NavigationLink(destination: ARCurrencyStatsView()
                                                .environmentObject(ARYearRatesFetcher("\(dayRate.Cur_ID)"))) {
                                                    ARCurrencyRow(rateModel: dayRate)
                                            }
                                }
                            }
                        }

                        if !self.monthRates.rates.isEmpty {
                            Section(header: self.monthRateSectionHeader()) {
                                ForEach(self.monthRates.rates,
                                        id: \.Cur_ID) { monthRate in
                                            ARCurrencyRow(rateModel: monthRate)
                                }
                            }
                        }
                    }
                    .sheet(isPresented: self.$showCountryRate, content: {
                        ARCurrencyStatsView()
                            .environmentObject(ARYearRatesFetcher("145"))
                    })
                }
            }
            .navigationBarTitle(Text("Курсы НБ РБ"))
        }
    }
}

struct AllRatesView_Previews: PreviewProvider {
    static var previews: some View {
        ARAllRatesView()
    }
}
