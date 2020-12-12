//
//  ARStatsForDayModel.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

struct ARStatsForDayModel: Hashable, Identifiable, Codable {
    var id: Int?
    /// внутренний код
    var Cur_ID: Int
    /// дата, на которую запрашивается курс
    var Date: String
    /// курс
    var Cur_OfficialRate: Double
}
