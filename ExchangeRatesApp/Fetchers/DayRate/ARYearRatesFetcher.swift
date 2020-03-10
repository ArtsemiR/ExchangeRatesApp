//
//  ARYearRatesFetcher.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/13/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

final class ARYearRatesFetcher: ObservableObject {
    @Published var rates: [ARStatsForDayModel] = []

    let curId: String

    private enum CurrencyType: String, CaseIterable {
        case usd = "USD"
        case eur = "EUR"
        case rub = "RUB"
        case uah = "UAH"
        case pln = "PLN"
    }

    init(_ curId: String) {
        self.curId = curId
        self.load()
    }

    public func load() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        ARNetwork.shared.request(
            action: "API/ExRates/Rates/Dynamics/\(self.curId)",
            parameters: ["startDate": formatter.string(from: Date()),
                         "endDate": formatter.string(from: Date(timeIntervalSinceNow: -365*24*60*60))]) { [weak self] (response: [ARStatsForDayModel]) in
                            self?.rates = response
        }
    }
}
