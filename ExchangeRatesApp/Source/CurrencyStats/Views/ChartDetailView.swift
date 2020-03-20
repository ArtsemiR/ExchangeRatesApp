//
//  ChartDetailView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/18/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ChartDetailView: View {

    var title: String
    var value: String
    
    var body: some View {
        VStack {
            HStack {
                Text(self.title)
                Spacer()
                Text(self.value)
            }
            Divider()
        }
        .frame(height: 50)
    }
}

struct ChartDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChartDetailView(title: "Title", value: "value")
    }
}
