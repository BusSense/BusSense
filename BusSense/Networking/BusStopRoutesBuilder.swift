//
//  StopsForLocationStopMonitoringFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/22/23.
//

import Foundation

// MARK: - BusStopRoutesBuilder
class BusStopRoutesBuilder: ObservableObject {
    @Published var busStopRoutes = [BusStopRoutes]()
    @Published var isLoading = false
    
    func buildBusStopRoutes(lat: Double, lon: Double) {
        
        isLoading = true
        let stopsForLocation = StopsForLocationFetcher()
        stopsForLocation.fetchAllBusStops(lat: lat, lon: lon)
        
        if let errorMessageStopsForLocation = stopsForLocation.errorMessage {
            print("StopsForLocation Error")
            print(errorMessageStopsForLocation)
        } else {
            // let stopMonitoring = StopMonitoringFetcher()
            print(stopsForLocation.busStops)
        }
        
        isLoading = false
    }
}
