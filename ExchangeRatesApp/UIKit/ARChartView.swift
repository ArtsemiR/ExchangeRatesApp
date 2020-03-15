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

    @EnvironmentObject var yearRatesFetcher: ARYearRatesFetcher

    let chartView = ARChartView()

    func makeUIView(context: Context) -> ARChartView {
        return chartView
    }

    func updateUIView(_ uiView: ARChartView, context: Context) {
        uiView.setChart(rates: self.yearRatesFetcher.rates)
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
    var label = UILabel()

    var labelLeadingMarginConstraint: NSLayoutConstraint!
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!

    init() {
        super.init(frame: CGRect.zero)

        self.addSubview(label)
        self.addSubview(chart)

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.numberOfLines = 0
        self.chart.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.label.heightAnchor.constraint(equalToConstant: 42),

            self.chart.topAnchor.constraint(equalTo: self.label.bottomAnchor),
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

    func setChart(rates: [ARStatsForDayModel]) {
        let mappedRates = rates.map { (date: $0.Date,rate: $0.Cur_OfficialRate)  }
        self.rates = mappedRates

        var serieData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: [String] = []

        // Date formatter to retrieve the month names
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"

        for (i, value) in mappedRates.enumerated() {
            serieData.append(value.rate)

            // Use only one label for each month
            let responseFormatter = DateFormatter()
            responseFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let date = responseFormatter.date(from: value.date) else { return }

            let month = Int(monthFormatter.string(from: date))!
            let monthAsString:String = monthFormatter.monthSymbols[month - 1]
            if (labels.count == 0 || labelsAsString.last != monthAsString) {
                labels.append(Double(i))
                labelsAsString.append(monthAsString)
            }
        }

        let series = ChartSeries(mappedRates.map { $0.rate })
        series.area = true

        chart.lineWidth = 1
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

        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {

            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 4
            label.text = numberFormatter.string(from: NSNumber(value: value))
            label.text?.append("\n\(self.rates[indexes[0] ?? 0].date.formattedDate())")
            self.setNeedsUpdateConstraints()

            // Align the label to the touch left position, centered
            var constant = labelLeadingMarginInitialConstant + left - (label.frame.width / 2)

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
        }
    }

    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }

    func didEndTouchingChart(_ chart: Chart) {

    }
}
