//
//  ARGraphView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 12/11/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARGraphView: View {
    @EnvironmentObject var userData: UserData

    var chart: LinesSet
    var colorXAxis: Color = Color.secondary
    var colorXMark: Color = Color.primary
    var indent: CGFloat = 0

    var index: Int {userData.charts.firstIndex(where: { $0.id == chart.id })!}

    func rangeTimeFor(indexChat: Int) -> Range<Int> {
        let numberPoints = userData.charts[indexChat].xTime.count
        let rangeTime: Range<Int>  = Int(userData.charts[indexChat].lowerBound * CGFloat(numberPoints - 1))..<Int(userData.charts[indexChat].upperBound * CGFloat(numberPoints - 1))
        return rangeTime
    }

    var body: some View {
        GeometryReader { geometry in
            VStack  (alignment: .leading, spacing: 10) {
                Text("   CHART \(self.index + 1):  \(self.chart.xTime.first!) - \(self.chart.xTime.last!)  \(self.chart.lines.count)  lines")
                    .font(.headline)
                    .foregroundColor(Color("ColorTitle"))
                Text(" ").font(.footnote)

                GraphsViewForChart(
                    chart: self.userData.charts[self.index],
                    rangeTime: self.rangeTimeFor (indexChat: self.index))
                    .padding(self.indent)
                    .frame(height: geometry.size.height  * 0.63)

                TickerView(rangeTime: self.rangeTimeFor (indexChat: self.index),chart: self.userData.charts[self.index], colorXAxis: self.colorXAxis, colorXMark: self.colorXMark, indent: self.indent)
                    .frame(height: geometry.size.height  * 0.058)

                RangeView(chart: self.userData.charts[self.index], indent: self.indent)
                    .environmentObject(self.userData)
                    .frame(height: geometry.size.height  * 0.1)

                CheckMarksView(chart: self.userData.charts[self.index])
                    .frame(height: geometry.size.height  * 0.05)

                Text(" ").font(.footnote)
            } // VStack
        } // Geometry
    }
}

struct ARGraphView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        ARGraphView(chart: chartsData[0])
              .environmentObject(UserData())
              .navigationBarTitle(Text("Followers"))
        }
        .colorScheme(.dark)
    }
}

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

extension AnyTransition {
    static var moveAndFadeMarks: AnyTransition {
        let insertion = AnyTransition.move(edge: .top)
            .combined(with: .opacity)

        let removal = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension Int {
    func formatNumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = " "
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 1
        if 1000 < self  && self < 999000 {
            let newValue = (Double(self) / Double(1000))
            return (formater.string(from: NSNumber(value: newValue))! + " K")
        }
        if 1000000 < self  && self < 999000000 {
            let newValue = Double(self) / Double(1000000)
            return (formater.string(from: NSNumber(value: newValue ))! + " M")
        }
        return formater.string(from: NSNumber(value: self))!
    }
}

extension Range where Bound: Numeric {
    var distance: Bound {
        return upperBound - lowerBound
    }
}

// Data
extension String {

    func hexStringToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension Color {
    public init(uiColor: UIColor) {
        let r, g, b, a: Double

                    r = Double(uiColor.rgba.red)
                    g = Double(uiColor.rgba.green)
                    b = Double(uiColor.rgba.blue)
                    a = Double(uiColor.rgba.alpha)

                    self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}



