/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Helpers for loading images and data.
 */

import Foundation
import UIKit
import SwiftUI
import Combine

let columns: [ChartElement] = load("chart.json")
let periodRatesData: [LinesSet] = addID(charts: convertToInternalModel(yearRates))

func addID(charts : [LinesSet] ) -> [LinesSet] {
    var i = 0
    var newCharts: [LinesSet] = []
    for chart in charts {
        var newChart = chart
        newChart.id = i
        newChart.lowerBound = 0.3
        newChart.upperBound = 0.8
        newCharts.append(newChart)
        i += 1
    }
    return newCharts
}

func convertToInternalModel(_ dayStats: [ARStatsForDayModel]) -> [LinesSet] {
    var graph = LinesSet()

    graph.namex = "x"
    graph.xTime = dayStats.map { $0.Date }

    let points = dayStats.map { Int($0.Cur_OfficialRate * 100) }

    var lines: [Line] = []
    lines.append(Line(id: 1,
                      title: "title",
                      points: points,
                      color: "#3DC23F".hexStringToUIColor(),
                      isHidden: false,
                      type: "type",
                      countY: points.count))

    graph.colorX = "#3DC23F".hexStringToUIColor()
    graph.lines = lines
    return [graph]
}
