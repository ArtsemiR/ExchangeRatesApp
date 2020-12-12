//
//  ARActivityIndicatorView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 3/13/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI
import UIKit

struct ARActivityIndicatorView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        return activityIndicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
