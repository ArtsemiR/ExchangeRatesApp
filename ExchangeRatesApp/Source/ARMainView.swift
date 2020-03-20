//
//  ARMainViewUIView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/10/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARMainView: View {

    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            ARAllRatesView()
                .environmentObject(ARDayRatesFetcher())
                .environmentObject(ARMonthRatesFetcher())
                .tabItem {
                    VStack {
                        Image(systemName: "list.dash")
                        Text("Курсы")
                    }
            }
            .tag(0)
            Text("Конвертер")
                .tabItem {
                    VStack {
                        Image(systemName: "arrow.right.arrow.left")
                        Text("Конвертер")
                    }
            }
            .tag(1)
        }
        .accentColor(.red)
    }
}

struct ARMainViewUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARMainView()
    }
}
