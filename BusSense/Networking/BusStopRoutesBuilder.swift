//
//  StopsForLocationStopMonitoringFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/22/23.
//

import Foundation

// MARK: - BusStopRoutesBuilder
/// Combine data from stops-for-location and stop-monitoring API calls
/// to only use the bus stop name and route destinations for user display.
/// Should be used in BusStopResultsView
class BusStopRoutesBuilder: ObservableObject {
    @Published var busStopRoutes = [BusStopRoutes]()
    @Published var isLoading = false
    
    func buildBusStopRoutes(lat: Double, lon: Double) {
        
        isLoading = true
        let stopsForLocation = StopsForLocationFetcher()
        // TODO: - Use optional completion handler to fetch all bus stops first
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
