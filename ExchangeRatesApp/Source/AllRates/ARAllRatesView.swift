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

    private var dayRatesList: [ARDayRateModel] {
        return self.dayRates.rates.filter { Defaults.shared.countryCodes.contains($0.Cur_ID) }
    }
    private var monthRatesList: [ARDayRateModel] {
        return self.monthRates.rates.filter { Defaults.shared.countryCodes.contains($0.Cur_ID) }
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
                } else if self.dayRates.error != nil {
                    ARActivityIndicatorView().scaleEffect(2)
                    Text(String(self.dayRates.error ?? ""))
                        .padding()
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                } else if self.monthRates.error != nil {
                    ARActivityIndicatorView().scaleEffect(2)
                        .padding()
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                    Text(String(self.monthRates.error ?? ""))
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 12) {
                            if !self.dayRatesList.isEmpty {
                                self.dayRateSectionHeader
                                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                                ForEach(self.dayRatesList,
                                        id: \.Cur_ID) { dayRate in
                                            NavigationLink(destination:
                                                ARLazyView(ARCurrencyStatsView(rateModel: dayRate)
                                                    .environmentObject(ARYearRatesFetcher("\(dayRate.Cur_ID)")))) {
                                                        ARCurrencyRow(rateModel: dayRate, isNeedRightArrow: true)
                                            }
                                }
                            }

                            if !self.monthRatesList.isEmpty {
                                self.monthRateSectionHeader
                                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                                ForEach(self.monthRatesList,
                                        id: \.Cur_ID) { monthRate in
                                            ARCurrencyRow(rateModel: monthRate)
                                }
                            }
                        }.id(UUID())
                    }
                }
            }
            .navigationBarTitle("Курсы НБ РБ")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isModal = true
                }, label: {
                    Text("Изменить")
                        .bold()
                })
            )
            .sheet(isPresented: $isModal, content: {
                ARChooseCountryView(showSheetView: self.$isModal)
                    .environmentObject(self.dayRates)
                    .environmentObject(self.monthRates)
            })
        }
    }
}


struct AllRatesView_Previews: PreviewProvider {
    static var previews: some View {
        ARAllRatesView()
    }
}
