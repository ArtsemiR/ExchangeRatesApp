//
//  ARStatsForDayModel.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftyUserDefaults

struct ARStatsForDayModel: Hashable, Identifiable, Codable, DefaultsSerializable {
    var id: Int?
    /// внутренний код
    var Cur_ID: Int
    /// дата, на которую запрашивается курс
    var Date: String
    /// курс
    var Cur_OfficialRate: Double
}

class ARStatsForDaySerializableModel: Codable, DefaultsSerializable {
    let code: String
    var model: [ARStatsForDayModel]

    init(code: String, model: [ARStatsForDayModel]) {
        self.code = code
        self.model = model
    }
}
