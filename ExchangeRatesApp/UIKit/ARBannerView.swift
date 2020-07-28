//
//  ARBannerView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 7/28/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMobileAds

final class ARBannerView: UIViewControllerRepresentable {

    let adUnitID: String

    init(_ adUnitID: String) {
        self.adUnitID = adUnitID
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = adUnitID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
