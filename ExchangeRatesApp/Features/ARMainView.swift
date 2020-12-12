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
    @State private var dayFetcher = ARDayRatesFetcher()
    @State private var monthFetcher = ARMonthRatesFetcher()

    var body: some View {
        TabView(selection: $selection) {
            ARAllRatesView()
                .environmentObject(self.dayFetcher)
                .environmentObject(self.monthFetcher)
                .tabItem {
                    VStack {
                        Image("list_icon")
                            .renderingMode(.template)
                            .foregroundColor(.red)
                        Text("Курсы")
                    }
            }.tag(0)
            ARConverterView()
                .environmentObject(self.dayFetcher)
                .environmentObject(self.monthFetcher)
                .tabItem {
                    VStack {
                        Image("converter_icon")
                            .renderingMode(.template)
                            .foregroundColor(.red)
                        Text("Конвертер")
                    }
            }.tag(1)
            ARDevaluationView()
                .tabItem {
                    VStack {
                        Image("chart_icon")
                            .renderingMode(.template)
                            .foregroundColor(.red)
                        Text("BYN")
                    }
            }.tag(2)
        }
        .accentColor(.red)
    }
}

struct ARMainViewUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARMainView()
    }
}
