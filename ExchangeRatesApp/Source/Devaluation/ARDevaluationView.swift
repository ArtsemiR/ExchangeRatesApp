//
//  ARDevaluationView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 7/9/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARDevaluationView: View {

    @State private var yearRatesFetcherRus = ARYearRatesFetcher("298")
    @State private var yearRatesFetcherUsd = ARYearRatesFetcher("145")
    @State private var yearRatesFetcherEur = ARYearRatesFetcher("292")

    @State private(set) var periodSelection = 0

    private var rates: [ARStatsForDayModel] {
        switch self.periodSelection {
        case 0:
            return self.devaluationFor(.month)
        case 1:
            return self.devaluationFor(.month3)
        case 2:
            return self.devaluationFor(.year)
        default:
            return self.devaluationFor(.year)
        }
    }

    enum Period {
        case month, month3, year
    }
    private func devaluationFor(_ period: Period) -> [ARStatsForDayModel] {
        var _period = 90
        switch period {
        case .month:
            _period = 30
        case .month3:
            _period = 90
        case .year:
            _period = self.yearRatesFetcherRus.rates.count
        }

        let yearRatesRus = self.yearRatesFetcherRus.rates.suffix(_period)
        let yearRatesUsd = self.yearRatesFetcherUsd.rates.suffix(_period)
        let yearRatesEur = self.yearRatesFetcherEur.rates.suffix(_period)
        var rates: [ARStatsForDayModel] = []
        for i in 0..<_period {
            let rate = pow(yearRatesRus[yearRatesRus.startIndex + i].Cur_OfficialRate, 0.5)
                * pow(yearRatesUsd[yearRatesUsd.startIndex + i].Cur_OfficialRate, 0.3)
                * pow(yearRatesEur[yearRatesEur.startIndex + i].Cur_OfficialRate, 0.2)
            rates.append(ARStatsForDayModel(id: i,
                                            Cur_ID: 0,
                                            Date: yearRatesRus[yearRatesRus.startIndex + i].Date,
                                            Cur_OfficialRate: rate))
        }
        return rates
    }

    private var devaluationView: ChartDetailView {
        if let minRate = self.rates.first?.Cur_OfficialRate,
            let lastRate = self.rates.last?.Cur_OfficialRate {
            let devaluation = (lastRate - minRate) * 100.0 / minRate
            let stringVal = String(format: "\(devaluation > 0 ? "+" : "")%.2f", devaluation)
            return ChartDetailView(title: devaluation > 0 ? "Девальвация" : "Ревальвация",
                            value: "\(stringVal) %",
                            status: devaluation > 0 ? .up : .down,
                            isLast: true)
        }
        return ChartDetailView(title: "Разница",
                               value: "--",
                               status: .none,
                               isLast: true)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 2) {
                if self.yearRatesFetcherRus.isLoading
                    || self.yearRatesFetcherUsd.isLoading
                    || self.yearRatesFetcherEur.isLoading {
                    ARActivityIndicatorView()
                } else if self.yearRatesFetcherRus.error != nil {
                    ARActivityIndicatorView().scaleEffect(2)
                    Text(String(self.yearRatesFetcherRus.error ?? ""))
                        .padding()
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                } else {

                        ARChartSwiftUIView(periodSelection: self.$periodSelection.wrappedValue,
                                           rates: self.rates)
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                        ARChartPeriodView(periodSelection: self.$periodSelection)
                            .frame(height: 30)
                        self.devaluationView
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 32, trailing: 8))
//                    GeometryReader { (geometry) in
//                        ARBannerView(adUnitID: "ca-app-pub-2699836089641813/7757906294",
//                                     width: geometry.size.width)
//                    }
//                    .frame(height: 50)
                }
            }
            .navigationBarTitle("Корзина Валют")
            .navigationBarItems(trailing:
                NavigationLink(destination: ARCurrencyCartInfoView()) {
                    Text("Что это?")
                }com.apple.uikit.eventfetch-thread (6)
            )
        }
    }
}
