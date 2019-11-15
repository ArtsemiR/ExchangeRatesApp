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

    init() {
        load()
    }

    func load() {
        ARNetwork.shared.userRequest(
            fullPath: ARNetwork.shared.baseUrl,
            action: "API/ExRates/Rates?Periodicity=0",
            model: nil) { (response: [ARDayRateModel]) in
                self.rates = response
        }
    }
}
