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
    case ddMWordyyyy
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

        if format == .ddMWordyyyy {
            let monthDict = ["01": "января", "02": "февраля",
                             "03": "марта", "04": "апреля", "05": "мая",
                             "06": "июня", "07": "июля", "08": "августа",
                             "09": "сентября", "10": "октября", "11": "ноября",
                             "12": "декабря"]

            var str = ""
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd"
            if let date = dateFormatterGet.date(from: self) {
                str.append(dateFormatterPrint.string(from: date))

                dateFormatterPrint.dateFormat = "MM"
                str.append(" \(monthDict[dateFormatterPrint.string(from: date)] ?? dateFormatterPrint.string(from: date)) ")

                dateFormatterPrint.dateFormat = "yyyy"
                str.append(dateFormatterPrint.string(from: date))
            }
            return str
        }

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
