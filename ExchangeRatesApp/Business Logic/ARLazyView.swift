//
//  ARLazyView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/16/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARLazyView<Content: View>: View {

    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        self.build()
    }
}
