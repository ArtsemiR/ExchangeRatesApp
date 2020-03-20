//
//  ARCurrencyStatsView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/10/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARCurrencyStatsView: View {

    @EnvironmentObject var yearRatesFetcher: ARYearRatesFetcher

    private let rateModel: ARDayRateModel

    private var devaluation: String {
        if let minRate = self.yearRatesFetcher.rates.first?.Cur_OfficialRate {
            return ((minRate - rateModel.Cur_OfficialRate) * 100.0 / minRate).toAmountString
        }
        return "--"
    }

    private var maxRate: String {
        return self.yearRatesFetcher.rates.map { $0.Cur_OfficialRate }.max()?.toAmountString ?? "--"
    }

    private var minRate: String {
        return self.yearRatesFetcher.rates.map { $0.Cur_OfficialRate }.max()?.toAmountString ?? "--"
    }

    init(rateModel: ARDayRateModel) {
        self.rateModel = rateModel
    }

    var body: some View {
        VStack(spacing: 4) {
            if self.yearRatesFetcher.isLoading {
                ARActivityIndicatorView()
            } else {
                ARCurrencyRow(rateModel: self.rateModel, isNeedCurrency: true)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 0, trailing: 8))
                ARChartSwiftUIView()
                    .environmentObject(self.yearRatesFetcher)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                ChartDetailView(title: "Девальвация", value: "\(self.devaluation) %")
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                ChartDetailView(title: "Максимум", value: self.maxRate)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                ChartDetailView(title: "Минимум", value: self.minRate)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 25, trailing: 8))
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}
