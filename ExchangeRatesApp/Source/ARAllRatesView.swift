//
//  ARAllRatesView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/15/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARAllRatesView: View {

    @ObservedObject var dayRatesFetcher = ARDayRatesFetcher(.day)
    @ObservedObject var monthRatesFetcher = ARDayRatesFetcher(.month)

    @State private var showModal = false
    @State private var selectedCurrencyName = ""

    // MARK: - ui
    
    private func dayRateSectionHeader() -> Text {
        var date: String = ""
        if let resDate = self.dayRatesFetcher.rates.first?.Date {
            date = "за \(resDate.formattedDate())"
        }
        return Text("\("Ежедневный курс") \(date)")
    }

    private func monthRateSectionHeader() -> Text {
        var date: String = ""
        if let resDate = self.monthRatesFetcher.rates.first?.Date {
            date = "за \(resDate.formattedDate())"
        }
        return Text("\("Ежемесячный курс") \(date)")
    }

    // MARK: Body

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    if !self.dayRatesFetcher.rates.isEmpty {
                        Section(header: self.dayRateSectionHeader()) {
                            ForEach(self.dayRatesFetcher.rates,
                                    id: \.Cur_ID) { dayRate in
                                        ARCurrencyRow(rateModel: dayRate)
                                            .onTapGesture { self.showModal.toggle() }
                            }
                        }
                    }

                    if !self.monthRatesFetcher.rates.isEmpty {
                        Section(header: self.monthRateSectionHeader()) {
                            ForEach(self.monthRatesFetcher.rates.sorted(
                                by: ({ $0.Cur_OfficialRate > $1.Cur_OfficialRate })),
                                    id: \.Cur_ID) { dayRate in
                                        ARCurrencyRow(rateModel: dayRate)
                                            .onTapGesture { self.showModal.toggle() }
                            }
                        }
                    }
                } //List
                    .sheet(isPresented: self.$showModal, content: {
                        ARCurrencyStatsView()
                            .frame(height: geometry.size.height)
                    })
                .navigationBarTitle(Text("Курсы НБ РБ"))
            } //Geometry
        }
    }
}

struct AllRatesView_Previews: PreviewProvider {
    static var previews: some View {
        ARAllRatesView()
    }
}
