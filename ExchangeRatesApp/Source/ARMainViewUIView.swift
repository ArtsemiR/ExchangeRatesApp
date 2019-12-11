//
//  ARMainViewUIView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/10/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARMainViewUIView: View {
    var body: some View {
        TabView {
            ARAllRatesView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Курсы")
                }
            Text("Конвертер")
                .tabItem {
                    Image(systemName: "arrow.right.arrow.left")
                    Text("Конвертер")
                }
        }
    }
}

struct ARMainViewUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARMainViewUIView()
    }
}
