//
//  DoubleEx.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/21/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

extension Double {
    public var toAmountString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 4

        return formatter.string(from: NSNumber(value: self)) ?? ""
    }

    public var toAmountStringWith2Zeros: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
