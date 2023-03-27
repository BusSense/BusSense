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
    @Published var busStopRoutes = [BusStopRoute]()
    @Published var isLoading = false
    @Published var hasFetchedCompleted = false
    private var stopsForLocationFetched = StopsForLocationFetcher()
    private var stopMonitoringFetched = StopMonitoringFetcher()
    
    func buildBusStopRoutes(lat: Double, lon: Double) {
        
        hasFetchedCompleted = false
        isLoading = true
        // TODO: - Use optional completion handler to fetch all bus stops first
        let group = DispatchGroup()
        group.enter()
        stopsForLocationFetched.fetchAllBusStops(lat: lat, lon: lon) {
//            if self.stopsForLocationFetched.errorMessage != nil && self.stopsForLocationFetched.hasFetchCompleted {
//                print("Bus stops:")
//                self.parser(self.stopsForLocationFetched.busStops!.busStops)
//            } else {
//                print("Failed to load in time")
//            }
//
//            self.hasFetchedCompleted = true
//            self.isLoading = false
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global()) {
            if let busStops = self.stopsForLocationFetched.busStops {
                print("From bus stop route builder")
                print(busStops)
                self.parser(busStops.busStops)
            } else {
                print("no bus stops available")
            }
        }
    }
    
    func parser(_ busStops: [BusStop]) {
//        var busStopRoutes: [BusStopRoutes] = []
        for busStop in busStops {
            print("bus stop")
            print(busStop.name)
            print(busStop.code)
            print()
            
            let group = DispatchGroup()
            group.enter()
            self.stopMonitoringFetched.fetchStopMonitoring(monitoringRef: busStop.code) {
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.global()) {
                if let monitoredStops = self.stopMonitoringFetched.monitoredStops {
                    var routes: [RouteDetail] = []
                    for monitoredStop in monitoredStops {
                        let monitoredVehicleJourney = monitoredStop.monitoredVehicleJourney
                        let publishedLineName = monitoredVehicleJourney.publishedLineName[0]
                        let destinationName = monitoredVehicleJourney.destinationName[0]
                        let lineNameAndDestinationNameView = "\(publishedLineName) - \(destinationName)"
                        if !self.containsRoute(lineAndDestination: lineNameAndDestinationNameView, routes: routes) {
//                            print(lineNameAndDestinationNameView)
                            let routeDetail = RouteDetail(lineRef: monitoredVehicleJourney.lineRef,
                                                          directionRef: monitoredVehicleJourney.directionRef,
                                                          journeyPatternRef: monitoredVehicleJourney.journeyPatternRef,
                                                          publishedLineName: monitoredVehicleJourney.publishedLineName[0],
                                                          operatorRef: monitoredVehicleJourney.operatorRef,
                                                          originRef: monitoredVehicleJourney.originRef,
                                                          destinationRef: monitoredVehicleJourney.destinationRef,
                                                          destinationName: monitoredVehicleJourney.destinationName[0],
                                                          lineNameAndDestinationName: lineNameAndDestinationNameView)
                            routes.append(routeDetail)
                        }
                    }
                    
                    let busStopRoute = BusStopRoute(code: busStop.code,
                                                    id: busStop.id,
                                                    name: busStop.name,
                                                    direction: busStop.direction,
                                                    lat: busStop.lat,
                                                    lon: busStop.lon,
                                                    locationType: busStop.locationType,
                                                    routes: routes)
                    
                    DispatchQueue.main.async {
                        self.busStopRoutes.append(busStopRoute)
                        self.hasFetchedCompleted = true
                        self.isLoading = false
                    }
                    
                    
                } else if let err = self.stopMonitoringFetched.errorMessage {
                    print(err)
                }
            }
        }
    }
    
    func containsRoute(lineAndDestination: String, routes: [RouteDetail]) -> Bool {
        return routes.contains { $0.lineNameAndDestinationName == lineAndDestination }
    }
}
