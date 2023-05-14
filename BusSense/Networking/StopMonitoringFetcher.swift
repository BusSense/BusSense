//
//  MTASIRIFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/21/23.
//

import Foundation
import BackgroundTasks
import UserNotifications

// needs to inherit ObservableObject to allow it to be used in UI
class StopMonitoringFetcher: ObservableObject {
    
    @Published var monitoredStops: [MonitoredStopVisit]? = nil
    @Published var isLoading: Bool = false
    @Published var hasFetchCompleted: Bool = false
    @Published var errorMessage: String? = nil
    var previousProximity: String? = nil
    
    static var shared: StopMonitoringFetcher = StopMonitoringFetcher()
    
    // Store these 3 variables for notifying users
    static var busStop: BusStopRoute? = nil
    static var busRoute: RouteDetail? = nil
    static var stopMonitoringFetcher: StopMonitoringFetcher? = nil
    
//    init() {
//        fetchStopMonitoring()
//    }
    
    // This will be called in BusTrackingView so we have access to the bus being tracked
    func initData(busStop1: BusStopRoute, busRoute1: RouteDetail, stopMonitoringFetcher1: StopMonitoringFetcher){
        print("init data")
//        print(busStop1)
//        print(busRoute1)
        StopMonitoringFetcher.busStop = busStop1
        StopMonitoringFetcher.busRoute = busRoute1
        StopMonitoringFetcher.stopMonitoringFetcher = stopMonitoringFetcher1
    }
    
    static func scheduleAppRefresh() {
        Task{
            // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
//            try? await Task.sleep(nanoseconds: 7_500_000_000)
            print("scheduling app refresh")
//            await StopMonitoringFetcher.handleBackgroundTask()
            
            // Start background task in 30 seconds
            let request = BGAppRefreshTaskRequest(identifier: "myapprefresh")
            request.earliestBeginDate = .now.addingTimeInterval(5)
            try? BGTaskScheduler.shared.submit(request)
        }
    }
    
    static func handleBackgroundTask() async{
        print("handle background task")
        // Schedule another task
        scheduleAppRefresh()
        
        // Fetch updates
        Task{
            let stopMonitoringFetcher = StopMonitoringFetcher.stopMonitoringFetcher
            let busStop = StopMonitoringFetcher.busStop
            let busRoute = StopMonitoringFetcher.busRoute
            
            guard stopMonitoringFetcher != nil else {return}
            guard busStop != nil else {return}
            guard busRoute != nil else {return}
            
            // Wait for updates
            await stopMonitoringFetcher!.fetchStopMonitoring(monitoringRef: busStop!.code, lineRef: busRoute!.lineRef.replacingOccurrences(of: " ", with: "%20"))
            
            // Send notification to users
            print("notification test")
        }
    }
    
    func scheduleNotification() {
        print("schedule notifiction")
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        let proximityText = self.getProximityAway()
        
        // Same as previous dont notify
        if(self.previousProximity == proximityText){
            return
        }
        
        // Update previous
        self.previousProximity = proximityText
        
        content.title = "Bus Update"
        content.body = "Your bus is \(proximityText) away"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func fetchStopMonitoring (monitoringRef: String, lineRef: String? = nil, completion: @escaping () -> Void = {}) async{
        DispatchQueue.main.async {
//            print("entered fetchStopMonitoring")
            // start of fetching data
            self.isLoading = true
            self.hasFetchCompleted = false
            // resets errorMessage everytime function is called
            self.errorMessage = nil
            
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
//                            print(monitoredStopVisit)
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
    }
    
//    func fetchStopMonitoring(monitoringRef: String, lineRef: String? = nil) {
//        // start of fetching data
//        isLoading = true
//        hasFetchCompleted = false
//        // resets errorMessage everytime function is called
//        errorMessage = nil
//
//        let key = "test"
//        let version = "2"
//        var url = URL(string: "")
//
//        let group = DispatchGroup()
//        let serialQueue = DispatchQueue(label: "url")
//        group.enter()
//        serialQueue.sync {
//            if let lineRef = lineRef {
//                url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)&LineRef=\(lineRef)")
//            } else {
//                url = URL(string: "https://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)")
//            }
//            group.leave()
//        }
//
//        group.enter()
//        serialQueue.sync {
//            Task.init {
//                defer {
//                    DispatchQueue.main.async {
//                        self.isLoading = false
//                        self.hasFetchCompleted = true
//                    }
//                }
//                do {
//                    let monitoredStops = try await APIService().fetch(type: StopMonitoring.self, from: url!)
//                    DispatchQueue.main.async {
//                        self.monitoredStops = monitoredStops.monitoredStopVisit
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//            group.leave()
//        }
//    }
    
    func getProximityAway() -> String{
        let empty = monitoredStops?.isEmpty ?? false
        guard self.hasFetchCompleted && !empty else { return "No vehicles detected at this time. Please try again later."}
            // return miles first vehicle is away from stop
        return StopMonitoringFetcher.shared
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .arrivalProximityText
    }
    
    func getMetersAway() -> Int{
        let empty = monitoredStops?.isEmpty ?? false
        guard self.hasFetchCompleted && !empty else { return 0 }
            // return miles first vehicle is away from stop
            return StopMonitoringFetcher.shared
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .distanceFromStop
    }
    
    func getStopsAway() -> Int{
        let empty = monitoredStops?.isEmpty ?? false
        guard self.hasFetchCompleted && !empty else { return 0 }
            // return miles first vehicle is away from stop
            return self
            .monitoredStops![0]
            .monitoredVehicleJourney
            .monitoredCall
            .numberOfStopsAway
    }
    
    func getTimeAway() -> String{
        let empty = monitoredStops?.isEmpty ?? false
        guard self.hasFetchCompleted && !empty else { return "No vehicles detected at this time. Please try again later."}
        
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
