//
//  ARDefaultKeys.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/12/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {

    var dayRates: DefaultsKey<[ARDayRateModel]?> { return .init("dayRates") }
    var monthRates: DefaultsKey<[ARDayRateModel]?> { return .init("yearRates") }
}
