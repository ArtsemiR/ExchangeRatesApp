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
    let width: CGFloat

    init(adUnitID: String,
         width: CGFloat) {
        self.width = width

        #if DEBUG
        self.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        // бой
        self.adUnitID = adUnitID
        #endif
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.translatesAutoresizingMaskIntoConstraints = false

        let viewController = UIViewController()
        viewController.view.addSubview(banner)
        banner.rootViewController = viewController

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            banner.leftAnchor.constraint(equalTo: viewController.view.leftAnchor),
            banner.rightAnchor.constraint(equalTo: viewController.view.rightAnchor),
            banner.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        banner.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(self.width)
        banner.load(GADRequest())

        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
