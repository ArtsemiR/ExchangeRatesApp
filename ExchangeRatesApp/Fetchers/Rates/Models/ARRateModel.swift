//
//  ARRateModel.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

struct ARRateModel: Decodable {
    /// внутренний код
    var Cur_ID: Int
    /// этот код используется для связи, при изменениях наименования, количества единиц к которому устанавливается курс белорусского рубля, буквенного, цифрового кодов и т.д. фактически одной и той же валюты.
    var Cur_ParentID: Int
    /// цифровой код
    var Cur_Code: String
    /// буквенный код
    var Cur_Abbreviation: String
    /// наименование валюты на русском языке
    var Cur_Name: String
    /// наименование на белорусском языке
    var Cur_Name_Bel: String
    /// наименование на английском языке
    var Cur_Name_Eng: String
    /// наименование валюты на русском языке, содержащее количество единиц
    var Cur_QuotName: String
    /// наименование на белорусском языке, содержащее количество единиц
    var Cur_QuotName_Bel: String
    /// наименование на английском языке, содержащее количество единиц
    var Cur_QuotName_Eng: String
    ///наименование валюты на русском языке во множественном числе
    var Cur_NameMulti: String
    /// наименование валюты на белорусском языке во множественном числе
    var Cur_Name_BelMulti: String
    /// наименование на английском языке во множественном числе
    var Cur_Name_EngMulti: String
    /// количество единиц иностранной валюты
    var Cur_Scale: Int
    /// периодичность установления курса (0 – ежедневно, 1 – ежемесячно)
    var Cur_Periodicity: Int
    /// дата включения валюты в перечень валют, к которым устанавливается официальный курс бел. рубля
    var Cur_DateStart: String
    /// дата исключения валюты из перечня валют, к которым устанавливается официальный курс бел. рубля
    var Cur_DateEnd: String
}

struct ARDayRateModel: Hashable, Identifiable, Codable {
    var id: Int?
    /// внутренний код
    var Cur_ID: Int
    /// дата, на которую запрашивается курс
    var Date: String
    /// буквенный код
    var Cur_Abbreviation: String
    /// количество единиц иностранной валюты
    var Cur_Scale: Int
    /// наименование валюты на русском языке во множественном, либо в единственном числе, в зависимости от количества единиц
    var Cur_Name: String
    /// курс
    var Cur_OfficialRate: Double
}
