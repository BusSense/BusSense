//
//  MTASIRIFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/21/23.
//

import Foundation

// needs to inherit ObservableObject to allow it to be used in UI
class StopMonitoringFetcher: ObservableObject {
    
    @Published var monitoredStops: [MonitoredStopVisit]? = nil
    @Published var isLoading: Bool = false
    @Published var hasFetchCompleted: Bool = false
    @Published var errorMessage: String? = nil
    
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
    
    func getProximityAway() -> String{
        guard self.hasFetchCompleted && !monitoredStops!.isEmpty else { return "No vehicles detected at this time. Please try again later."}
        
        // return miles first vehicle is away from stop
        return self.monitoredStops![0].monitoredVehicleJourney.monitoredCall.arrivalProximityText
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
    
    func getMilesAway() -> String {
        let metersAway = getMetersAway()
        let milesAway = Float(metersAway) * 0.0006213712
        let rounded = round(milesAway * 10) / 10.0
//        self.milesAway = String(rounded)
        return String(rounded)
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
        
//        if monitoredStops != nil {
//            let arrivingTime = self.monitoredStops![0].monitoredVehicleJourney.monitoredCall.expectedArrivalTime ?? ""
//            print("expected arrival time:", arrivingTime)
//            let formatter = ISO8601DateFormatter()
//            formatter.timeZone = TimeZone(abbreviation: "EST")
//            formatter.formatOptions = [
//                .withInternetDateTime,
//                .withFractionalSeconds
//            ]
//            let isoDate = formatter.date(from: arrivingTime)
//
//            print("iso 8601 date:", isoDate as Any)
//            print("current time:", currDate)
//
//            let diffs = Calendar.current.dateComponents([.hour, .minute], from: currDate, to: isoDate!)
//
//            let hourInt = diffs.hour!
//            let minuteInt = diffs.minute!
//            let formattedHour = timeStringFormatter(hourInt, for: "hour")
//            let formattedMinute = timeStringFormatter(minuteInt, for: "minute")
//
//            if hourInt > 0 && minuteInt > 0 {
//                status = formattedHour + " and " + formattedMinute + " away"
//            } else if hourInt > 0 && minuteInt == 0 {
//                status = formattedHour + " away"
//            } else if hourInt == 0 {
//                status = formattedMinute + " away"
//            }
//        } else {
//            let arrivingTime = self.monitoredStops![0].monitoredVehicleJourney.monitoredCall.aimedArrivalTime ?? ""
//        }
        
        
        // return miles first vehicle is away from stop
        return status
    }
}
