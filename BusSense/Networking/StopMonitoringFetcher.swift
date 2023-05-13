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
        print("entered fetchStopMonitoring")
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
                        print(monitoredStopVisit)
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
    
    @MainActor
    func fetchStopMonitoring(monitoringRef: String, lineRef: String? = nil) {
        // start of fetching data
        isLoading = true
        hasFetchCompleted = false
        // resets errorMessage everytime function is called
        errorMessage = nil
        
        let key = "test"
        let version = "2"
        var url = URL(string: "")
        
        if let lineRef = lineRef {
            url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)&LineRef=\(lineRef)")
        } else {
            url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)")
        }
        
        Task.init {
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.hasFetchCompleted = true
                }
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url!)
                let decoder = JSONDecoder()
                let monitoredStops = try decoder.decode(StopMonitoring.self, from: data)
                DispatchQueue.main.async {
                    self.monitoredStops = monitoredStops.monitoredStopVisit
                }
            } catch {
                print(error)
            }
        }
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
