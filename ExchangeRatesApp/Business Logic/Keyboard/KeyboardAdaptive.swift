//
//  KeyboardAdaptive.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 4/23/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {

    let willChange = PassthroughSubject<CGFloat, Never>()

    private(set) var currentHeight: CGFloat = 0 {
        willSet {
            willChange.send(currentHeight)
        }
    }

    let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .first() // keyboardWillShow notification may be posted repeatedly
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height }

    let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat(0) }

    func listen() {
        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.currentHeight, on: self)
    }

    init() {
        listen()
    }
}

struct AdaptsToSoftwareKeyboard: ViewModifier {

    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight)
            .edgesIgnoringSafeArea(currentHeight == 0 ? Edge.Set() : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height }

    private let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }

    private func subscribeToKeyboardEvents() {
        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.currentHeight, on: self)
    }
}
