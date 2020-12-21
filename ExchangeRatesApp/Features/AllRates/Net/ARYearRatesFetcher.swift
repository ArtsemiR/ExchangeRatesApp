//
//  ARYearRatesFetcher.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/13/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

final class ARYearRatesFetcher: ObservableObject {

    @Published var rates: [ARStatsForDayModel] = []
    @Published private(set) var isLoading = false
    var error: Bool = false

    let curId: String

    init(_ curId: String) {
        self.curId = curId
        self.load()
    }

    public func load() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        self.isLoading = true
        ARNetwork.shared.request(
            action: "API/ExRates/Rates/Dynamics/\(self.curId)",
            parameters: [
                "startDate": formatter.string(from: Date(timeIntervalSinceNow: -364*24*60*60)),
                "endDate": formatter.string(from: Date())],
            okHandler: { [weak self] (response: [ARStatsForDayModel]) in
                guard let self = self else { return }
                self.rates = response
                Defaults.yearRates?[self.curId] = response
                self.isLoading = false
        },
            errorHandler: { [weak self] in
                guard let self = self else { return }
                self.error = true
                if let rates = Defaults.yearRates?[self.curId] {
                    self.rates = rates
                }
                self.isLoading = false
        })
    }
}
