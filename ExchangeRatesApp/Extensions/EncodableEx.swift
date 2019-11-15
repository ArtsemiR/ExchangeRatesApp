//
//  EncodableEx.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .customEncoder
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    func toData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .customEncoder
        let data = try encoder.encode(self)
        return data
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let customDecoder = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.baseFormat.date(from: string) ?? Formatter.reserveFormat.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let customEncoder = custom { date, encoder throws in
        var container = encoder.singleValueContainer()
        try container.encode(Formatter.baseFormat.string(from: date))
    }
}

extension Formatter {
    static let baseFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmmss"

        return formatter
    }()

    static let reserveFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmmss"

        return formatter
    }()
}
