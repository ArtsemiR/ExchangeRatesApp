//
//  CheckMarksViewNewView.swift
//  RectangleSwiftUI
//
//  Created by Tatiana Kornilova on 28/06/2019.
//  Copyright © 2019 Tatiana Kornilova. All rights reserved.
//

import SwiftUI

struct CheckMarksView : View {
    @EnvironmentObject var userData: ARUserData
    var chart: LinesSet
    
    private var chartIndex: Int {
        userData.periodRates.firstIndex(where: { $0.id == chart.id })!
    }

    private func lineIndex(line: Line) -> Int {
        userData.periodRates[chartIndex].lines.firstIndex(where: { $0.id == line.id})!
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack (alignment: .top) {
                ForEach(self.chart.lines) { line in
                    SimulatedButton(line:  self.$userData.periodRates[self.chartIndex].lines[self.lineIndex(line: line)])
                } //ForEach
            } //HStack
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .topLeading)
        } //Geometry
    } //body
}

struct CheckMarksView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckMarksView(chart: periodRatesData[0])
                .frame( height: 40)
                .environmentObject(ARUserData())
        } // Navigation
        .colorScheme(.dark)
    }
}
