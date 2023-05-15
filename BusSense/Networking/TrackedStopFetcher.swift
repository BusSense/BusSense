//
//  TrackedStopFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 5/15/23.
//

import Foundation

class TrackedStopFetcher: ObservableObject {
    
    @Published var monitoredStops: [MonitoredStopVisit]? = nil
    @Published var trackedBus: MonitoredVehicleJourney? = nil
    @Published var isLoading: Bool = false
    @Published var hasFetchCompleted: Bool = false
    @Published var errorMessage: String? = nil
    @Published var proximityMsg: String? = nil
    @Published var milesAway: String? = nil
    @Published var timeAway: String? = nil
    @Published var busesAhead: String? = nil
    
//    init() {
//        fetchStopMonitoring()
//    }
    
    func fetchStopMonitoring(monitoringRef: String, lineRef: String? = nil, completion: @escaping () -> Void = {}) {
//        print("entered fetchStopMonitoring")
        // start of fetching data
        isLoading = true
        hasFetchCompleted = false
        // resets errorMessage everytime function is called
        errorMessage = nil
        
        let key = "test"
        let version = "2"
        let service = APIService()
        var url = URL(string: "")
        
        if let lineRef = lineRef {
            url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)&LineRef=\(lineRef)")
        } else {
            url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)")
        }
        
        service.fetch(StopMonitoring.self, url: url) { [unowned self] result in
            DispatchQueue.main.async {
                // indicate data request has completed
                self.isLoading = false
                self.hasFetchCompleted = true
                // handle results
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                    completion()
                case .success(let monitoredStop):
                    if let monitoredStopVisit = monitoredStop.monitoredStopVisit {
                        self.monitoredStops = monitoredStopVisit
//                        print(monitoredStopVisit)
                        completion()
                    } else {
                        // indicates that there were no returned buses for the bus stop
                        self.monitoredStops = []
                        completion()
                    }
                }
            }
        }
    }
    
    func updateTrackedData() {
        
    }
    
    func getProximityAway() -> String{
        guard hasFetchCompleted && monitoredStops != nil else { return "No vehicles detected at this time. Please try again later."}
        
        // return miles first vehicle is away from stop
        return self.monitoredStops![0].monitoredVehicleJourney.monitoredCall.arrivalProximityText
    }
    
    func getMetersAway() -> Int{
        guard hasFetchCompleted && !monitoredStops!.isEmpty else { return 0 }
            // return miles first vehicle is away from stop
            return self
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .distanceFromStop
    }
    
    func getMilesAway() -> String {
        let metersAway = getMetersAway()
        let milesAway = Float(metersAway) * 0.0006213712
        let rounded = round(milesAway * 10) / 10.0
        return String(rounded)
    }
    
    func getStopsAway() -> Int{
        guard hasFetchCompleted && monitoredStops != nil else { return 0 }
            // return miles first vehicle is away from stop
            return self
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .numberOfStopsAway
    }
    
    func timeStringFormatter(_ value: Int, for type: String) -> String {
        var timeType = type
        
        // determines if singular or plural
        if value != 1 {
            timeType = timeType.replacingOccurrences(of: type, with: type + "s")
        }
        
        return String(value) + " " + timeType
    }
    
    func getTimeAway() -> String{
        guard self.hasFetchCompleted && self.monitoredStops != nil else { return "0 minutes away"}
        
        let currDate = Date()
        var curr = Calendar.current
        curr.timeZone = TimeZone(abbreviation: "EST")!
        
        var status = ""
        
        print("getTimeAway:", monitoredStops as Any)
        
        let arrivingTime = self.monitoredStops![0].monitoredVehicleJourney.monitoredCall.expectedArrivalTime ?? ""
        print("expected arrival time:", arrivingTime)
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "EST")
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        let isoDate = formatter.date(from: arrivingTime)
        
        print("iso 8601 date:", isoDate as Any)
        print("current time:", currDate)
        
        let diffs = Calendar.current.dateComponents([.hour, .minute], from: currDate, to: isoDate!)
        
        let hourInt = diffs.hour!
        let minuteInt = diffs.minute!
        let formattedHour = timeStringFormatter(hourInt, for: "hour")
        let formattedMinute = timeStringFormatter(minuteInt, for: "minute")
        
        if hourInt > 0 && minuteInt > 0 {
            status = formattedHour + " and " + formattedMinute + " away"
        } else if hourInt > 0 && minuteInt == 0 {
            status = formattedHour + " away"
        } else if hourInt == 0 {
            status = formattedMinute + " away"
        }
        
        // return miles first vehicle is away from stop
        return status
    }
    
    func busesAhead(stop: BusStopRoute, route: RouteDetail) -> [(Date, String)] {

            // array of tuples (oncoming time and bus to that specific stop)
            var arrivingTimes: [(day: Date, bus: String)] = []

            let currDate = Date()
            var curr = Calendar.current

            // get all buses arriving at stop
            fetchStopMonitoring(monitoringRef: stop.code)

            for x in monitoredStops! {

                var nextTime = x.monitoredVehicleJourney.monitoredCall.expectedArrivalTime

                var date = DateComponents()
                date.year = Int(String(nextTime!.prefix(4))) ?? 0
                date.month = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 6)..<nextTime!.index(nextTime!.endIndex, offsetBy: -22)]) ?? 0
                date.day = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 8)..<nextTime!.index(nextTime!.endIndex, offsetBy: -19)]) ?? 0
                date.timeZone = TimeZone(abbreviation: "EST")
                date.hour = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 11)..<nextTime!.index(nextTime!.endIndex, offsetBy: -16)]) ?? 0
                date.minute = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 15)..<nextTime!.index(nextTime!.endIndex, offsetBy: -13)]) ?? 0
                date.second = Int(nextTime![nextTime!.index(nextTime!.startIndex, offsetBy: 18)..<nextTime!.index(nextTime!.endIndex, offsetBy: -10)]) ?? 0
                let arrivingDateTime = curr.date(from: date)!

                arrivingTimes.append((arrivingDateTime, x.monitoredVehicleJourney.lineRef))
            }

                arrivingTimes = arrivingTimes.sorted(by: {$0.day < $1.day})


            return arrivingTimes
        }

        // count the number of buses ahead of the desired bus
        func ahead(route: RouteDetail, arrivingTimes: [(Date, String)]) -> Int {

            var numberofBus = 0
            for i in arrivingTimes {
                if i.1 != route.lineRef {
                    numberofBus += 1
                }
            }
            return numberofBus
        }
}
