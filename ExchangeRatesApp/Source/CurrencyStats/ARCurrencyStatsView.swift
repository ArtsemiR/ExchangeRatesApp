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
    private var rates: [ARStatsForDayModel] {
        var array: [ARStatsForDayModel] = []
        switch self.periodSelection {
        case 0:
            array = self.yearRatesFetcher.rates.suffix(30)
        case 1:
            array = self.yearRatesFetcher.rates.suffix(90)
        case 2:
            array = self.yearRatesFetcher.rates
        default:
            array = self.yearRatesFetcher.rates
        }
        return array
    }

    private var devaluationView: ChartDetailView {
        if let minRate = self.rates.first?.Cur_OfficialRate {
            let devaluation = (self.rateModel.Cur_OfficialRate - minRate) * 100.0 / self.rateModel.Cur_OfficialRate
            let stringVal = String(format: "\(devaluation > 0 ? "+" : "")%.2f", devaluation)
            return ChartDetailView(
                title: devaluation > 0 ? "Девальвация" : "Ревальвация",
                value: "\(stringVal) %",
                status: devaluation > 0 ? .up : .down,
                isLast: false)
        }
        return ChartDetailView(title: "Разница",
                               value: "--",
                               status: .none,
                               isLast: false)
    }

    private var maxRateView: ChartDetailView {
        let stringVal = self.rates.map { $0.Cur_OfficialRate }.max()?.toAmountString ?? "--"
        return ChartDetailView(title: "Максимум",
                               value: stringVal,
                               status: .none,
                               isLast: false)
    }

    private var minRateView: ChartDetailView {
        let stringVal = self.rates.map { $0.Cur_OfficialRate }.min()?.toAmountString ?? "--"
        return ChartDetailView(title: "Минимум",
                               value: stringVal,
                               status: .none,
                               isLast: true)
    }

    init(rateModel: ARDayRateModel) {
        self.rateModel = rateModel
    }

    var body: some View {
        VStack(spacing: 2) {
            if self.yearRatesFetcher.isLoading {
                ARActivityIndicatorView()
            } else if self.yearRatesFetcher.error != nil {
                ARActivityIndicatorView().scaleEffect(2)
                Text(String(self.yearRatesFetcher.error ?? ""))
                    .padding()
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            } else {
                ARCurrencyRow(rateModel: self.rateModel, isNeedCurrency: true)
                    .padding(EdgeInsets(top: 4, leading: 5, bottom: 0, trailing: 8))
                ARChartSwiftUIView(periodSelection: self.$periodSelection.wrappedValue,
                                   rates: self.rates)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                ARChartPeriodView(periodSelection: self.$periodSelection)
                    .frame(height: 30)
                self.devaluationView
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8))
                self.maxRateView
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                self.minRateView
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 32, trailing: 8))
//                GeometryReader { (geometry) in
//                    ARBannerView(adUnitID: "ca-app-pub-2699836089641813/6342658949",
//                                 width: geometry.size.width)
//                }.frame(height: 50)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}
