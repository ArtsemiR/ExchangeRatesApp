//
//  ContentView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/6/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let extractedExpr: Text = Text("Hello, World!")
    var body: some View {
        VStack(alignment: .leading) {
            Text("Placeholder")
                .font(.title)
                .fontWeight(.semibold)
            extractedExpr
                .font(.subheadline)
                .foregroundColor(.green)
        }
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
