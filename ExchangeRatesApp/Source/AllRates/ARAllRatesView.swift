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

    @State private var selectedCurrencyName = ""

    @State var isModal: Bool = false

    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }

    // MARK: - ui
    
    private var dayRateSectionHeader: Text {
        var date: String = ""
        if let resDate = self.dayRates.rates.first?.Date {
            date = "на \(resDate.formattedDate(format: .ddMMyyyy))"
        }
        return Text("\("Ежедневный курс") \(date)")
            .fontWeight(.thin)
    }

    private var monthRateSectionHeader: Text {
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
                    ARActivityIndicatorView().scaleEffect(2)
                } else {
                    List {
                        if !self.dayRates.rates.isEmpty {
                            Section(header: self.dayRateSectionHeader) {
                                ForEach(self.dayRates.rates.filter { Defaults.countryCodes().contains($0.Cur_ID) },
                                        id: \.Cur_ID) { dayRate in
                                            NavigationLink(destination:
                                                ARLazyView(ARCurrencyStatsView(rateModel: dayRate)
                                                    .environmentObject(ARYearRatesFetcher("\(dayRate.Cur_ID)")))) {
                                                        ARCurrencyRow(rateModel: dayRate)
                                                            .frame(height: 60)
                                            }
                                }
                            }
                        }

                        if !self.monthRates.rates.isEmpty {
                            Section(header: monthRateSectionHeader) {
                                ForEach(self.monthRates.rates.filter { Defaults.countryCodes().contains($0.Cur_ID) },
                                        id: \.Cur_ID) { monthRate in
                                            ARCurrencyRow(rateModel: monthRate)
                                                .frame(height: 60)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Курсы НБ РБ")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isModal = true
                }, label: {
                    Text("Изменить")
                })
                .sheet(isPresented: $isModal, content: {
                    ARChooseCountryView(showSheetView: self.$isModal)
                        .environmentObject(self.dayRates)
                        .environmentObject(self.monthRates)
                })
            )
        }
    }
}


struct AllRatesView_Previews: PreviewProvider {
    static var previews: some View {
        ARAllRatesView()
    }
}
