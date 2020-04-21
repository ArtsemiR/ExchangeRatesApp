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
                return String(((bynVal * scale) / self.rateModel.Cur_OfficialRate))
        },
            set: {
                guard let forVal = Double($0.replacingOccurrences(of: " ", with: "")) else { return }
                let scale = Double(self.rateModel.Cur_Scale)
                let byn = String(((forVal * self.rateModel.Cur_OfficialRate) / scale))

                self.changedRate = (code: self.rateModel.Cur_Abbreviation,
                                    amount: byn)
                print(self.changedRate)
        })
    }

    var body: some View {
        HStack {
            Text(ARRate.s.getFlag(self.rateModel.Cur_Abbreviation))
                .font(.largeTitle)
            Text(self.rateModel.Cur_Abbreviation)
                .fontWeight(.semibold)
            ARCurrencyInputView(isBYN: false, text: bindingString)
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

    private var bindingString: Binding<String> {
        Binding<String>(
            get: { self.changedRate.amount },
            set: { self.changedRate = (code: self.curCode, amount: $0) })
    }

    var body: some View {
        return HStack {
            Text(ARRate.s.getFlag(self.curCode))
                .font(.largeTitle)
            Text(self.curCode)
                .fontWeight(.semibold)
            ARCurrencyInputView(isBYN: true, text: bindingString)
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
