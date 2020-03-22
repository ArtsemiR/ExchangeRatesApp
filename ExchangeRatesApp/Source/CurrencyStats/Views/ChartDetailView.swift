//
//  ChartDetailView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/18/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ChartDetailView: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    enum Status {
        case none
        case up
        case down
    }

    let title: String
    let value: String
    let status: Status

    private var color: Color {
        switch self.status {
        case .none:
            return self.colorScheme == .light ? .black : .white
        case .up:
            return .red
        case .down:
            return .green
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(self.title)
                Spacer()
                Text(self.value)
                    .foregroundColor(self.color)
            }
            Divider()
        }
    }
}

struct ChartDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChartDetailView(title: "Title", value: "value", status: .none)
    }
}
