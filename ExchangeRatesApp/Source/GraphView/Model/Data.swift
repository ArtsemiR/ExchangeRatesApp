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
let periodRatesData: [LinesSet] = addID( charts: columns.compactMap { convertToInternalModel($0)})

func addID(charts : [LinesSet] ) -> [LinesSet] {
    var i = 0
    var newCharts = [LinesSet]()
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

func convertToInternalModel(_ chatti: ChartElement ) -> LinesSet {
    var nameLine = ""
    var values = [Int]()
    var graph = LinesSet()
    var lines = [Line] ()
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en-US")
    dateFormatter.setLocalizedDateFormatFromTemplate("MMM d yyyy")
    
    for line in chatti.columns {
        for element in line {
            switch element {
            case .integer(let value): values.append(value)
            case .string(let name): nameLine = name
            }
        }
        switch nameLine {
        case "x":
            graph.namex = "x"
            graph.xTime = values.map { dateFormatter.string (
                from:Date(timeIntervalSince1970: TimeInterval($0/1000))
                )
            }
        case "y0" :
            lines.append(Line(id: lines.count,
                              title: chatti.names.y0,
                              points: values,
                              color: chatti.colors.y0.hexStringToUIColor(),
                              isHidden: false,
                              type: chatti.types.y0,
                              countY: values.count))
        case "y1" :
            lines.append(Line(id: lines.count,
                              title: chatti.names.y1,
                              points: values,
                              color: chatti.colors.y1.hexStringToUIColor(),
                              isHidden: false,
                              type: chatti.types.y1,
                              countY: values.count))
        default: break
        }
        nameLine = ""
        values = [Int]()
        
    }
    graph.colorX = chatti.colors.x != nil ? chatti.colors.x!.hexStringToUIColor() : nil
    graph.lines = lines
    return graph
}

