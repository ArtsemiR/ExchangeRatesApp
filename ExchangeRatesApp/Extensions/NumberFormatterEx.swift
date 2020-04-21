//
//  NumberFormatterEx.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 4/21/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

extension NumberFormatter {
    class func formatNumber(value: String) -> String? {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        guard let numberToDouble = Double(value),
            let stringNumber = formatter.string(from: NSNumber(value: numberToDouble)) else { return nil }

        return stringNumber
    }
}
