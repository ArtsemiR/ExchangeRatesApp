//
//  ARDayRatesFetcher.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation
import Combine

final class ARDayRatesFetcher: ObservableObject {
    @Published var rates: [ARDayRateModel] = []

    public enum Mode {
        case day
        case month
    }
    let reqMode: Mode

    private enum CurrencyType: String, CaseIterable {
        case usd = "USD"
        case eur = "EUR"
        case rub = "RUB"
        case uah = "UAH"
        case pln = "PLN"
    }

    init(_ reqMode: Mode) {
        self.reqMode = reqMode
        self.load()
    }

    public func load() {
        ARNetwork.shared.userRequest(
            fullPath: ARNetwork.shared.baseUrl,
            action: "API/ExRates/Rates?Periodicity=\(self.reqMode == .day ? "0" : "1")",
            model: nil) { [weak self] (response: [ARDayRateModel]) in
                self?.setRates(response)
        }
    }

    private func setRates(_ response: [ARDayRateModel]) {
        var sortedCountries: [ARDayRateModel] = []
        CurrencyType.allCases.forEach { currency in
            response
                .filter { $0.Cur_Abbreviation == currency.rawValue }
                .forEach { (rate) in
                    sortedCountries.append(rate)
            }
        }
        let remaningCountries = response
            .filter { !sortedCountries.contains($0) }
        sortedCountries.append(contentsOf: remaningCountries)

        self.rates = sortedCountries
    }
}
