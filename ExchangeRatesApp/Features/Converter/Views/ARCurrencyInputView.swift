//
//  ARCurrencyInputView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 4/21/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import Foundation

import UIKit
import SwiftUI

struct ARCurrencyInputView: UIViewRepresentable {

    let isBYN: Bool

    @Binding var text: String
    @Binding var isFirstResponder: Bool

    func makeUIView(context: Context) -> ARCurrencyTextField {
        let textField = ARCurrencyTextField(
            stringAction: { (string) in self.text = string },
            firstResponderAction: { self.isFirstResponder = true })
        return textField
    }

    func updateUIView(_ uiView: ARCurrencyTextField, context: Context) {
        guard !uiView.isFirstResponder else { return }
        uiView.text = ARCurrencyTextField.formatAmount(self.text)
    }
}

final class ARCurrencyTextField: UITextField, UITextFieldDelegate {

    private var stringAction: ((String) -> Void)
    private var firstResponderAction: (() -> Void)

    required init(stringAction: @escaping ((String) -> Void),
                  firstResponderAction: @escaping (() -> Void)) {
        self.stringAction = stringAction
        self.firstResponderAction = firstResponderAction
        super.init(frame: CGRect.zero)
        self.delegate = self
        self.placeholder = "0"
        self.keyboardType = .decimalPad
        self.textAlignment = .right
        self.addTarget(self, action: #selector(self.changeEditing(_:)), for: UIControl.Event.editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        self.firstResponderAction()
        return super.becomeFirstResponder()
    }

    @objc func changeEditing(_ sender: UITextField) {
        let formattedText = ARCurrencyTextField.formatAmount(sender.text ?? "")
        sender.text = formattedText
        self.stringAction(formattedText)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Block leading space
        if range.location == 0 && string == " " {
            return false
        }

        switch string {
        case "":
            return true
        case ",", ".":
            if let text = textField.text,
                !text.contains(".") {
                textField.text?.append(".")
            }
            if let text = textField.text,
                text == "." || text == "," {
                textField.text = "0."
            }
            return false
        case "0":
            if let text = textField.text,
                text == "0" {
                return false
            }
        default:
            if let text = textField.text,
                text == "0" {
                textField.text = ""
                return true
            }
        }

        return true
    }

    static func formatAmount(_ text: String) -> String {
        var formattedString = "0"
        let cleanedString = text.replacingOccurrences(of: " ", with: "")

        let maxInt = 12

        if cleanedString.contains("."),
            cleanedString.last != "." {
            let ammountArray = cleanedString.split(separator: ".")
            if ammountArray.count == 2 {
                let integerPart = ammountArray[0].count < maxInt
                    ? ammountArray[0].description
                    : ammountArray[0].description.substring(start: 0, length: maxInt)
                let fractionaPart = ammountArray[1].count < 4
                    ? ammountArray[1].description
                    : ammountArray[1].description.substring(start: 0, length: 4)
                formattedString = NumberFormatter.formatNumber(value: integerPart) ?? ""
                if fractionaPart != "0" {
                    formattedString.append(".")
                    formattedString.append(fractionaPart)
                }
            }
        } else {
            formattedString = NumberFormatter.formatNumber(value: (cleanedString.count < maxInt
                ? cleanedString
                : cleanedString.substring(start: 0, length: maxInt))) ?? ""
        }

        return formattedString.isEmpty ? "0" : formattedString
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
