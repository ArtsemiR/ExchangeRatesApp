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

    // MARK: - Body

    private var bindingString: Binding<String> {
        Binding<String>(
            get: {
                guard let bynVal = Double(self.changedRate.amount.replacingOccurrences(of: " ", with: "")) else { return "0" }
                let scale = Double(self.rateModel.Cur_Scale)
                return ((bynVal * scale) / self.rateModel.Cur_OfficialRate).toAmountStringWithManyZeros
        },
            set: {
                let acceptableNumbers: String = " 0987654321."
                if CharacterSet(charactersIn: acceptableNumbers).isSuperset(of: CharacterSet(charactersIn: $0)) {
                    guard let forVal = Double($0.replacingOccurrences(of: " ", with: "")) else { return }
                    let scale = Double(self.rateModel.Cur_Scale)
                    let byn = ((forVal * self.rateModel.Cur_OfficialRate) / scale).toAmountStringWithManyZeros

                    self.changedRate = (code: self.rateModel.Cur_Abbreviation,
                                        amount: byn)
                    print(self.changedRate)
                } else {
                    self.changedRate = (code: self.rateModel.Cur_Abbreviation, amount: "0")
                }
        })
    }

    var body: some View {
        HStack {
            Text(ARRate.s.getFlag(self.rateModel.Cur_Abbreviation))
                .font(.largeTitle)
            Text(self.rateModel.Cur_Abbreviation)
                .fontWeight(.semibold)
            TextField("0",
                      text: bindingString,
                      onEditingChanged: { (changed) in
                        if changed {
                            //bindingString.wrappedValue = ""
                        }
            })
                .keyboardType(.numberPad)
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
                guard let val = Double($0.replacingOccurrences(of: " ", with: "")) else { return }
                self.changedRate = (code: "BYN", amount: val.toAmountStringWithManyZeros)
                print(self.changedRate)
        })

        return HStack {
            Text(ARRate.s.getFlag(self.curCode))
                .font(.largeTitle)
            Text(self.curCode)
                .fontWeight(.semibold)
            TextField("0",
                      text: bindingString)
                .keyboardType(.numberPad)
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
