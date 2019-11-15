//
//  AMRate.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/15/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

class AMRate {
    static let s: AMRate = AMRate()
    var flagsCache: [String: String] = [:]

    private init() {
        self.flagsCache["USD"] = "🇺🇸"
        self.flagsCache["EUR"] = "🇪🇺"
        self.flagsCache["XDR"] = "🏳️"
    }

    func getFlag(_ currencyCode: String) -> String {
        func flag(countryCode: String) -> String {
            var temp = ""
            for uS in countryCode.uppercased().unicodeScalars {
                temp.unicodeScalars.append(UnicodeScalar(127397 + uS.value)!)
            }
            return temp
        }

        let currencyCode = currencyCode.uppercased()
        if let flag = flagsCache[currencyCode] {
            return flag
        } else {
            for localeId in Locale.availableIdentifiers {
                let locale = Locale(identifier: localeId)
                if locale.currencyCode == currencyCode {
                    return flag(countryCode: locale.regionCode ?? "")
                }
            }
            return currencyCode
        }
    }
}
