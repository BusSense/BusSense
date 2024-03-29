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
    @Published var hasFetchCompleted = false
    private var stopsForLocationFetched = StopsForLocationFetcher()
    private var stopMonitoringFetched = StopMonitoringFetcher()
    
    func buildBusStopRoutes(lat: Double, lon: Double) {
        
        hasFetchCompleted = false
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
            if let busStops = self.stopsForLocationFetched.nearbyStops {
//                print("From bus stop route builder")
//                print(busStops)
                if (busStops.busStops.count != 0) {
//                    print("bus stop count:", busStops.busStops.count)
                    self.parser(busStops.busStops)
//                    print("parsing complete")
                } else {
                    print("0 bus stops nearby")
                    DispatchQueue.main.async {
                        self.hasFetchCompleted = true
                        self.isLoading = false
                    }
                }
            } else {
                print("no bus stops available")
            }
        }
        
//        let serialQueue = DispatchQueue(label: "fetchStopsForLocation")
//        
//        serialQueue.async {
//            print("task 1 started")
//            self.stopsForLocationFetched.fetchAllBusStops(lat: lat, lon: lon) {
//                print("completed fetch")
//            }
//            print("task 1 finished")
//        }
//        
//        serialQueue.async {
//            print("task 2 started")
//            if let busStops = self.stopsForLocationFetched.nearbyStops {
//                print("From bus stop route builder")
//                print(busStops)
//                if (busStops.busStops.count != 0) {
//                    print("bus stop count:", busStops.busStops.count)
//                    self.parser(busStops.busStops)
//                    print("parsing complete")
//                } else {
//                    print("0 bus stops nearby")
//                    DispatchQueue.main.async {
//                        self.hasFetchedCompleted = true
//                        self.isLoading = false
//                    }
//                }
//            } else {
//                print("no bus stops available")
//            }
//            print("task 2 finshed")
//        }
    }
    
    func parser(_ busStops: [BusStop]) {
//        var busStopRoutes: [BusStopRoutes] = []
        defer {
            DispatchQueue.main.async {
                self.hasFetchCompleted = true
                self.isLoading = false
            }
        }
        for busStop in busStops {
//            print("bus stop")
//            print(busStop.name)
//            print(busStop.code)
//            print(busStop)
            
            let group = DispatchGroup()
            group.enter()
//            print("entering group")
            self.stopMonitoringFetched.fetchStopMonitoring(monitoringRef: busStop.code) {
//                print("completion")
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.global()) {
                if let monitoredStops = self.stopMonitoringFetched.monitoredStops {
                    var routes: [RouteDetail] = []
//                    print(monitoredStops)
//                    print(routes)
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
//                    print(busStopRoute)
                    
                    DispatchQueue.main.async {
                        self.busStopRoutes.append(busStopRoute)
//                        self.hasFetchedCompleted = true
//                        self.isLoading = false
                    }
                    
                    
                } else if let err = self.stopMonitoringFetched.errorMessage {
                    print(err)
                }
            }
        }
//        print("end of parser")
    }
    
    func containsRoute(lineAndDestination: String, routes: [RouteDetail]) -> Bool {
        return routes.contains { $0.lineNameAndDestinationName == lineAndDestination }
    }
}
