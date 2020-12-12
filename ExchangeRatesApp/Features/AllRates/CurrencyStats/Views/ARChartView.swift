//
//  ARChartView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/13/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import UIKit
import SwiftUI

struct ARChartSwiftUIView: UIViewRepresentable {

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    let periodSelection: Int
    let rates: [ARStatsForDayModel]

    let chartView = ARChartView()

    func makeUIView(context: Context) -> ARChartView {
        return chartView
    }

    func updateUIView(_ uiView: ARChartView, context: Context) {
        uiView.updateTheme(theme: colorScheme)
        switch periodSelection {
        case 0:
            uiView.setChart(rates: self.rates)
        case 1:
            uiView.setChart(rates: self.rates)
        case 2:
            uiView.setChart(rates: self.rates)
        default:
            uiView.setChart(rates: self.rates)
        }
    }
}

final class ARChartView: UIView, ChartDelegate {

    private var rates: [(date: String,rate: Double)] = []

    // MARK: - Chart view

    private lazy var chart: Chart = {
        let view = Chart()
        view.delegate = self
        return view
    }()

    var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()

    var labelLeadingMarginConstraint: NSLayoutConstraint!
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!

    init() {
        super.init(frame: CGRect.zero)

        self.addSubview(self.label)
        self.insertSubview(self.chart, at: 0)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.chart.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),

            self.chart.topAnchor.constraint(equalTo: self.topAnchor),
            self.chart.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.chart.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.chart.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.labelLeadingMarginConstraint = self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.labelLeadingMarginConstraint.isActive = true
        self.labelLeadingMarginInitialConstant = self.labelLeadingMarginConstraint?.constant
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTheme(theme: ColorScheme) {
        if theme == .light {
            self.label.backgroundColor = #colorLiteral(red: 0.7852933407, green: 0.8643416762, blue: 0.9621810317, alpha: 1)
            self.chart.areaAlphaComponent = 0.3
        } else {
            self.label.backgroundColor = #colorLiteral(red: 0.1909946203, green: 0.3861761689, blue: 0.6175481677, alpha: 1)
            self.chart.areaAlphaComponent = 0.45
        }
    }

    func setChart(rates: [ARStatsForDayModel]) {
        self.chart.removeAllSeries()
        let mappedRates = rates.map { (date: $0.Date,rate: $0.Cur_OfficialRate)  }
        self.rates = mappedRates

        var serieData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: [String] = []

        // Date formatter to retrieve the month names
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"

        let monthDict = [1: "январь",
                         2: "февраль",
                         3: "март",
                         4: "апрель",
                         5: "май",
                         6: "июнь",
                         7: "июль",
                         8: "август",
                         9: "сентябрь",
                         10: "октябрь",
                         11: "ноябрь",
                         12: "декабрь"]

        for (i, value) in mappedRates.enumerated() {
            serieData.append(value.rate)

            // Use only one label for each month
            let responseFormatter = DateFormatter()
            responseFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let date = responseFormatter.date(from: value.date) else { return }

            let month = Int(monthFormatter.string(from: date))!
            let monthAsString:String = monthDict[month] ?? monthFormatter.monthSymbols[month - 1]
            if (labels.count == 0 || labelsAsString.last != monthAsString) {
                labels.append(Double(i))
                labelsAsString.append(monthAsString)
            }
        }
        labelsAsString[labelsAsString.startIndex] = ""

        let series = ChartSeries(mappedRates.map { $0.rate })
        series.area = true

        chart.lineWidth = 2
        chart.labelFont = UIFont.systemFont(ofSize: 12)
        chart.xLabels = labels
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
        chart.xLabelsTextAlignment = .left
        chart.yLabelsOnRightSide = true
        // Add some padding above the x-axis
        chart.minY = serieData.min()! - 0.2
        chart.maxY = serieData.max()! + 0.2

        chart.add(series)
    }


    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        label.isHidden = false
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {

            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 4

            let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
            let secondAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .thin)]

            let string = NSMutableAttributedString(string: "\(numberFormatter.string(from: NSNumber(value: value)) ?? "--") BYN",
                                                        attributes: firstAttributes)
            let secondString = NSAttributedString(string: "\n\(self.rates[indexes[0] ?? 0].date.formattedDate(format: .ddMWordyyyy))",
                                                  attributes: secondAttributes)
            string.append(secondString)

            label.attributedText = string
            self.setNeedsUpdateConstraints()

            // Align the label to the touch left position, centered
            var constant = labelLeadingMarginInitialConstant + left - label.frame.width - 3

            // Avoid placing the label on the left of the chart
            if constant < labelLeadingMarginInitialConstant {
                constant = labelLeadingMarginInitialConstant
            }

            // Avoid placing the label on the right of the chart
            let rightMargin = chart.frame.width - label.frame.width
            if constant > rightMargin {
                constant = rightMargin
            }

            labelLeadingMarginConstraint.constant = constant
            UIView.animate(withDuration: 0.2) {
                self.label.isHidden = false
            }
        }
    }

    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }

    func didEndTouchingChart(_ chart: Chart) {
        label.isHidden = true
    }
}
