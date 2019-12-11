//
//  ARRate.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/15/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

class ARRate {
    static let s: ARRate = ARRate()
    var flagsCache: [String: String] = [:]

    private init() {
        self.flagsCache["AUD"] = "🇦🇺"
        self.flagsCache["DKK"] = "🇩🇰"
        self.flagsCache["USD"] = "🇺🇸"
        self.flagsCache["EUR"] = "🇪🇺"
        self.flagsCache["XDR"] = "🌍"
        self.flagsCache["NONE"] = "🏴"
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
            var isoCountryCode: [String] = []
            Locale.isoRegionCodes.forEach { (code) in
                let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue : code]))
                if locale.currencyCode == currencyCode {
                    isoCountryCode.append(code)
                }
            }
            return flag(countryCode: isoCountryCode.first ?? "NONE")
        }
    }
}
