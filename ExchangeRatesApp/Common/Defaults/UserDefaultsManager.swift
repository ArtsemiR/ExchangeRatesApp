//
//  UserDefaultsManager.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 4/21/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

class ARUserDefaultsManager {
    static var shared: ARUserDefaultsManager = ARUserDefaultsManager()
    
    private let userDefault = UserDefaults.standard

    private init() {}

    lazy var countryCodes: [Int] = {
        return self.getCountryCodes()
    }()

    let countryCodesKey =  "countryCodes"
    func getCountryCodes() -> [Int] {
        if let codes = userDefault.object(forKey: self.countryCodesKey) as? [Int] {
            return codes
        } else {
            let array = [145, 292, 298, 290, 293]
            userDefault.set(array, forKey: countryCodesKey)
            return array
        }
    }
    func addCountryCode(_ code: Int) {
        var array = userDefault.object(forKey: countryCodesKey) as? [Int] ?? [145, 292, 298, 290, 293]
        array.append(code)
        self.countryCodes = array
        userDefault.removeObject(forKey: countryCodesKey)
        userDefault.set(array, forKey: countryCodesKey)
    }
    func removeCountryCode(_ code: Int) {
        let array = (userDefault.object(forKey: countryCodesKey) as? [Int] ?? [145, 292, 298, 290, 293])
            .filter { $0 != code }
        self.countryCodes = array
        userDefault.removeObject(forKey: countryCodesKey)
        userDefault.set(array, forKey: countryCodesKey)
    }
}
