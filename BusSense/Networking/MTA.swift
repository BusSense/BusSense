//
//  MTA.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 5/14/23.
//

import Foundation

class MTA: ObservableObject {
    @Published var busStopRoutes = [BusStopRoute]()
    @Published var isLoading: Bool = false
    @Published var hasFetchCompleted: Bool = false
    @Published var errorMessage: String? = nil
    private var nearbyStops: StopsForLocation? = nil
    private var monitoredStops: [MonitoredStopVisit]? = nil
    
    func fetchNearbyBusStops(lat: Double, lon: Double) {
        print("fetchNearbyBusStops")
        // start of fetching data
        isLoading = true
        hasFetchCompleted = false
        // resets errorMessage everytime function is called
        errorMessage = nil

        // TODO: - Set actual key in plist
        let key = "test"
        let version = "2"
        let radius = "10"
        let url = URL(string: "https://bustime.mta.info/api/where/stops-for-location.json?key=\(key)&version=\(version)&lat=\(lat)&lon=\(lon)&radius=\(radius)")

        Task {
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasFetchCompleted = true
                }
            }
            do {
                let nearbyStops = try await APIService().fetch(type: StopsForLocation.self, from: url!)
                DispatchQueue.main.async {
                    self.nearbyStops = nearbyStops
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchStopMonitoring(monitoringRef: String, lineRef: String? = nil) {
        // start of fetching data
        isLoading = true
        hasFetchCompleted = false
        // resets errorMessage everytime function is called
        errorMessage = nil

        let key = "test"
        let version = "2"
        var url = URL(string: "")

        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "url")
        group.enter()
        serialQueue.sync {
            if let lineRef = lineRef {
                url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)&LineRef=\(lineRef)")
            } else {
                url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)")
            }
            group.leave()
        }

        group.enter()
        serialQueue.sync {
            Task.init {
                defer {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.hasFetchCompleted = true
                    }
                }
                do {
                    let monitoredStops = try await APIService().fetch(type: StopMonitoring.self, from: url!)
                    DispatchQueue.main.async {
                        self.monitoredStops = monitoredStops.monitoredStopVisit
                    }
                } catch {
                    print(error)
                }
            }
            group.leave()
        }
    }
    
    func buildBusStopRoutes(lat: Double, lon: Double) {
//        print("buildBusStopRoutes")
        hasFetchCompleted = false
        isLoading = true
//        Task.init {
//            await stopsForLocationFetched.fetchNearbyBusStops(lat: lat, lon: lon)
//        }
        fetchNearbyBusStops(lat: lat, lon: lon)

        print(nearbyStops ?? "not fetched in time")

        if let nearbyStops = self.nearbyStops {
            print("From bus stop route builder new")
            print(nearbyStops)
            if (nearbyStops.busStops.count != 0) {
                print("bus stop count:", nearbyStops.busStops.count)
                self.parserNew(nearbyStops.busStops)
                print("parsing complete")
            } else {
                print("0 bus stops nearby")
                DispatchQueue.main.async {
                    self.hasFetchCompleted = true
                    self.isLoading = false
                }
            }
        } else {
            print("not supposed to go here")
        }
    }
    
    func parserNew(_ busStops: [BusStop]) {
        print("parser new")
        defer {
            DispatchQueue.main.async {
                self.hasFetchCompleted = true
                self.isLoading = false
            }
        }
        for busStop in busStops {
            print("bus stop")
            print(busStop.name)
            print(busStop.code)
            print(busStop)

            fetchStopMonitoring(monitoringRef: busStop.code)

            if let monitoredStops = self.monitoredStops {
                var routes: [RouteDetail] = []
                print(monitoredStops)
                print(routes)
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
                print(busStopRoute)

                DispatchQueue.main.async {
                    self.busStopRoutes.append(busStopRoute)
//                        self.hasFetchedCompleted = true
//                        self.isLoading = false
                }
            }
        }
    }
    
    func containsRoute(lineAndDestination: String, routes: [RouteDetail]) -> Bool {
        return routes.contains { $0.lineNameAndDestinationName == lineAndDestination }
    }
    
    func getProximityAway() -> String{
        guard self.hasFetchCompleted && !monitoredStops!.isEmpty else { return "No vehicles detected at this time. Please try again later."}
            // return miles first vehicle is away from stop
            return self
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .arrivalProximityText
    }
    
    func getMetersAway() -> Int{
        guard self.hasFetchCompleted && !monitoredStops!.isEmpty else { return 0 }
            // return miles first vehicle is away from stop
            return self
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .distanceFromStop
    }
    
    func getStopsAway() -> Int{
        guard self.hasFetchCompleted && !monitoredStops!.isEmpty else { return 0 }
            // return miles first vehicle is away from stop
            return self
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .numberOfStopsAway
    }
    
    func getTimeAway() -> String{
        guard self.hasFetchCompleted && !monitoredStops!.isEmpty else { return "No vehicles detected at this time. Please try again later."}
        
        let currDate = Date()
        var curr = Calendar.current
        curr.timeZone = TimeZone(abbreviation: "EST")!
        let components = curr.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currDate)
        
        let arrivingTime = self.monitoredStops![0].monitoredVehicleJourney.monitoredCall.expectedArrivalTime ?? ""
        
        var date = DateComponents()
        date.year = Int(String(arrivingTime.prefix(4))) ?? 0
        date.month = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 6)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -22)]) ?? 0
        date.day = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 8)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -19)]) ?? 0
        date.timeZone = TimeZone(abbreviation: "EST")
        date.hour = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 11)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -16)]) ?? 0
        date.minute = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 15)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -13)]) ?? 0
        date.second = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 18)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -10)]) ?? 0

        let arrivingDateTime = curr.date(from: date)!
        
        let diffs = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currDate, to: arrivingDateTime)
        
        let minAway = -1 * diffs.minute!
        let secAway = -1 * diffs.second!
        
        let status = String(minAway) + " minutes and " + String(secAway) + " seconds away"
        
        // return miles first vehicle is away from stop
        return status
    }
}
