//
//  ARRatesFetcher.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import UIKit

final class ARDayRatesFetcher: ObservableObject {

    @Published private(set) var rates: [ARDayRateModel] = []
    @Published private(set) var isLoading = false
    var error: Bool = false

    required init() {
        self.load()
    }

    public func load() {
        self.isLoading = true
        ARNetwork.shared.request(
            action: "API/ExRates/Rates?Periodicity=0",
            okHandler: { [weak self] (response: [ARDayRateModel]) in
                guard let self = self else { return }
                self.setRates(response)
                Defaults.dayRates = response
                self.isLoading = false
            },
            errorHandler: { [weak self] in
                guard let self = self else { return }
                self.error = true
                if let rates = Defaults.dayRates {
                    self.setRates(rates)
                }
                self.isLoading = false
        })
    }

    private func setRates(_ response: [ARDayRateModel]) {
        enum CurrencyType: String, CaseIterable {
            case usd = "USD"
            case eur = "EUR"
            case rub = "RUB"
            case uah = "UAH"
            case pln = "PLN"
        }

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

final class ARMonthRatesFetcher: ObservableObject {

    @Published private(set) var rates: [ARDayRateModel] = []
    @Published private(set) var isLoading = false
    var error: Bool = false

    required init() {
        self.load()
    }

    public func load() {
        self.isLoading = true
        ARNetwork.shared.request(
            action: "API/ExRates/Rates?Periodicity=1",
            okHandler: { [weak self] (response: [ARDayRateModel]) in
                guard let self = self else { return }
                self.setRates(response)
                self.isLoading = false
                Defaults.monthRates = response
            },
            errorHandler: { [weak self] in
                guard let self = self else { return }
                self.error = true
                if let rates = Defaults.monthRates {
                    self.setRates(rates)
                }
                self.isLoading = false
        })
    }

    private func setRates(_ response: [ARDayRateModel]) {
        enum CurrencyType: String, CaseIterable {
            case usd = "USD"
            case eur = "EUR"
            case rub = "RUB"
            case uah = "UAH"
            case pln = "PLN"
        }

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
