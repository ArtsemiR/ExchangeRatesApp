//
//  CurrencyConverterView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/29/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI
import UIKit

struct CurrencyConverterView: View {

    var rateModel: ARDayRateModel
    @Binding var changedRate: (code: String, amount: String)

    @State var currentValue: String = ""

    // MARK: - Body

    var body: some View {
        var bindingString = Binding<String>(
            get: {
                if self.changedRate.code == self.rateModel.Cur_Abbreviation {
                    return self.currentValue
                } else {
                    return (((Double(self.changedRate.amount) ?? 0.0)
                        * Double(self.rateModel.Cur_Scale))
                        / self.rateModel.Cur_OfficialRate).toAmountStringWith2Zeros
                }},
            set: {
                self.changedRate = (code: self.rateModel.Cur_Abbreviation,
                                    amount: ((Double($0) ?? 0.0)
                                        * self.rateModel.Cur_OfficialRate
                                        / self.rateModel.Cur_OfficialRate).toAmountStringWith2Zeros)
                self.currentValue = $0
                print(self.changedRate)
        })

        return HStack {
            Text(ARRate.s.getFlag(self.rateModel.Cur_Abbreviation))
                .font(.largeTitle)
            Text(self.rateModel.Cur_Abbreviation)
                .fontWeight(.semibold)
            TextField("0",
                      text: bindingString,
                      onEditingChanged: { (changed) in
                        if changed {
                            bindingString.wrappedValue = ""
                        }
            })
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(.headline)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.blue, lineWidth: 1))
                .padding()
        }.onTapGesture {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.endEditing(true)
        }
    }
}

struct BYNCurrencyConverterView: View {
    
    private let curCode = "BYN"
    @Binding var changedRate: (code: String, amount: String)

    // MARK: - Body

    var body: some View {
        let bindingString = Binding<String>(
            get: { self.changedRate.amount },
            set: {
                self.changedRate = (code: "BYN",
                                    amount: $0)
                print(self.changedRate)
        })

        return HStack {
            Text(ARRate.s.getFlag(self.curCode))
                .font(.largeTitle)
            Text(self.curCode)
                .fontWeight(.semibold)
            TextField("0",
                      text: bindingString)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(.headline)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.blue, lineWidth: 1))
                .padding()
        }.onTapGesture {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.endEditing(true)
        }
    }
}
