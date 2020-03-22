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

    @State private(set) var periodSelection = 0

    private let rateModel: ARDayRateModel

    private var devaluationView: ChartDetailView {
        if let minRate = self.yearRatesFetcher.rates.first?.Cur_OfficialRate {
            let devaluation = (self.rateModel.Cur_OfficialRate - minRate) * 100.0 / self.rateModel.Cur_OfficialRate
            let stringVal = String(format: "\(devaluation > 0 ? "+" : "")%.2f", devaluation)
            return ChartDetailView(title: "Разница",
                            value: "\(stringVal) %",
                            status: devaluation > 0 ? .up : .down)
        }
        return ChartDetailView(title: "Разница", value: "--", status: .none)
    }

    private var maxRateView: ChartDetailView {
        let stringVal = self.yearRatesFetcher.rates.map { $0.Cur_OfficialRate }.max()?.toAmountString ?? "--"
        return ChartDetailView(title: "Максимум", value: stringVal, status: .none)
    }

    private var minRateView: ChartDetailView {
        let stringVal = self.yearRatesFetcher.rates.map { $0.Cur_OfficialRate }.max()?.toAmountString ?? "--"
        return ChartDetailView(title: "Минимум", value: stringVal, status: .none)
    }

    init(rateModel: ARDayRateModel) {
        self.rateModel = rateModel
    }

    var body: some View {
        VStack(spacing: 2) {
            if self.yearRatesFetcher.isLoading {
                ARActivityIndicatorView()
            } else {
                ARCurrencyRow(rateModel: self.rateModel, isNeedCurrency: true)
                    .padding(EdgeInsets(top: 4, leading: 5, bottom: 0, trailing: 8))
                ARChartSwiftUIView(periodSelection: $periodSelection.wrappedValue)
                    .environmentObject(self.yearRatesFetcher)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                ARChartPeriodView(periodSelection: $periodSelection)
                    .frame(height: 30)
                self.devaluationView
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8))
                self.maxRateView
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                self.minRateView
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 32, trailing: 8))
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}
