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
        formatter.minimumFractionDigits = 2

        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
