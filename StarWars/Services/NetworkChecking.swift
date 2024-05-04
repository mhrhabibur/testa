//
//  NetworkChecking.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/29/24.
//

import Foundation
import Network

class NetworkChecking {
    public static let sharedInstance = NetworkChecking()
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isNetworkAvailable = true

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}
