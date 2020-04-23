//
//  ARNetworkStatus.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 4/23/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import Network

class ARNetStatus {

    // MARK: - Properties

    static let shared = ARNetStatus()

    var monitor: NWPathMonitor?

    var isMonitoring = false

    var didStartMonitoringHandler: (() -> Void)?

    var didStopMonitoringHandler: (() -> Void)?

    var netStatusChangeHandler: (() -> Void)?

    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }

    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }

        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }

    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }


    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }

    // MARK: - Init & Deinit

    private init() {}
    deinit { stopMonitoring() }


    // MARK: - Method Implementation

    func startMonitoring() {
        guard !isMonitoring else { return }

        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)

        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }

        isMonitoring = true
        didStartMonitoringHandler?()
    }


    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
}
