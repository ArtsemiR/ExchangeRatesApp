//
//  StringEx.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

public enum DateFormat: String {
    case ddMMyy = "dd.MM.yy"
    case ddMMyyyy = "dd.MM.yyyy"
}

extension String {
    
    public subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }

    public subscript(integerRange: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: integerRange.lowerBound)
        let end = index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return String(self[range])
    }

    public func formattedDate(format: DateFormat = .ddMMyy) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format.rawValue

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }

    func encodeForURL() -> String {
        let allowedSet = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "+"))
        return self.addingPercentEncoding(withAllowedCharacters: allowedSet) ?? self
    }
}
