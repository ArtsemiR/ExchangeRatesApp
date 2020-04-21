//
//  UserDefaultsManager.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 4/21/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

struct Defaults {
    private static let userDefault = UserDefaults.standard

    static let countryCodesKey =  "countryCodes"
    static func countryCodes() -> [Int] {
        if let codes = userDefault.object(forKey: countryCodesKey) as? [Int] {
            return codes
        } else {
            let array = [145, 292, 298, 290, 293]
            userDefault.set(array, forKey: countryCodesKey)
            return array
        }
    }
    static func addCountryCode(_ code: Int) {
        var array = userDefault.object(forKey: countryCodesKey) as? [Int] ?? [145, 292, 298, 290, 293]
        array.append(code)
        userDefault.removeObject(forKey: countryCodesKey)
        userDefault.set(array, forKey: countryCodesKey)
    }
    static func removeCountryCode(_ code: Int) {
        let array = (userDefault.object(forKey: countryCodesKey) as? [Int] ?? [145, 292, 298, 290, 293])
            .filter { $0 != code }
        userDefault.removeObject(forKey: countryCodesKey)
        userDefault.set(array, forKey: countryCodesKey)
    }
}
