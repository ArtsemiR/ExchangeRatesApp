import SwiftUI

final class ARUserData: ObservableObject {
    @Published var periodRates = periodRatesData

    func chartIndex(chart: LinesSet) -> Int {
        return periodRates.firstIndex(where: { $0.id == chart.id })!
    }
}
