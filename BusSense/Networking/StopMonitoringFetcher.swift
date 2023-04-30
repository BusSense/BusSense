//
//  MTASIRIFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/21/23.
//

import Foundation

// needs to inherit ObservableObject to allow it to be used in UI
class StopMonitoringFetcher: ObservableObject {
    
    @Published var monitoredStop = [MonitoredStopVisit]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isDone: Bool = false
    
//    init() {
//        fetchStopMonitoring()
//    }
    
//    func fetchHelper(URL: URL){
//        var request1 = URLRequest(url: URL,timeoutInterval: Double.infinity)
//        request1.httpMethod = "GET"
//        print("making request")
//        URLSession.shared.dataTask(with: request1) { data, response, error in
//            if let data = data {
//                print(data)
//                print("data fetched")
//                do{
//                    let decodedResponse =  try JSONDecoder().decode(RawServerResponseStopMonitoring.self, from: data)
//
//                            print("data decoded")
//                            // we have good data – go back to the main thread
//                            print(decodedResponse)
//                            print("hello world decode")
//                            DispatchQueue.main.async {
//                            // update our UI
//
//
//    //                    print(decodedResponse.data.stops[0].name)
//                    }
//                }catch let error as NSError {
//
//                    print("\(error)") //Error Domain=Swift.DecodingError Code=2 "(null)"
//
//
//                 }
//
//            } else {
//                // if we're still here it means there was a problem
//                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//        }.resume()
//    }
    
    func getMilesAway() -> String{
        guard self.isDone && !monitoredStop.isEmpty else { return "No vehicles detected at this time. Please try again later."}
            // return miles first vehicle is away from stop
            return self
                .monitoredStop[0]
                .MonitoredVehicleJourney
                .MonitoredCall
                .ArrivalProximityText
    }
    
    func getMetersAway() -> Int{
        guard self.isDone && !monitoredStop.isEmpty else { return 0}
            // return meters first vehicle is away from stop
            return self
                .monitoredStop[0]
                .MonitoredVehicleJourney
                .MonitoredCall
                .DistanceFromStop
    }
    
    func getStopsAway() -> Int{
        guard self.isDone && !monitoredStop.isEmpty else { return 0}
            // return stops first vehicle is away from stop
            return self
                .monitoredStop[0]
                .MonitoredVehicleJourney
                .MonitoredCall
                .NumberOfStopsAway
    }
    
    func getTimeAway() -> String{
        guard self.isDone && !monitoredStop.isEmpty else { return "No vehicles detected at this time. Please try again later."}
            // return time first vehicle is away from stop
        
//        let date1 = Date()
//        let calender = Calendar.current
//        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date1)
//
//        let arrivingTime = self.monitoredStop[0].MonitoredVehicleJourney.MonitoredCall.ExpectedArrivalTime ?? ""
//
//        // "2023-04-29T21:36:41.124-04:00"
//
//        var date = DateComponents()
//        date.year = Int(String(arrivingTime.prefix(4))) ?? 0
//        date.month = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 6)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -22)]) ?? 0
//        date.day = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 8)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -19)]) ?? 0
//        date.timeZone = TimeZone(abbreviation: "EST")
//        date.hour = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 12)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -16)]) ?? 0
//        date.minute = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 15)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -13)]) ?? 0
//        date.second = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 18)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -10)]) ?? 0
//
//        let dateAndTime = calender.date(from: date)
        
        let currDate = Date()
        var curr = Calendar.current
        curr.timeZone = TimeZone(abbreviation: "EST")!
        let components = curr.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currDate)

        let arrivingTime = self.monitoredStop[0].MonitoredVehicleJourney.MonitoredCall.ExpectedArrivalTime ?? ""

        var date = DateComponents()
        date.year = Int(String(arrivingTime.prefix(4))) ?? 0
        date.month = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 6)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -22)]) ?? 0
        date.day = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 8)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -19)]) ?? 0
        date.timeZone = TimeZone(abbreviation: "EST")
        date.hour = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 11)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -16)]) ?? 0
        date.minute = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 15)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -13)]) ?? 0
        date.second = Int(arrivingTime[arrivingTime.index(arrivingTime.startIndex, offsetBy: 18)..<arrivingTime.index(arrivingTime.endIndex, offsetBy: -10)]) ?? 0

        let arrivingDateTime = curr.date(from: date)!

        let difference = curr.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currDate, to: arrivingDateTime)
        let hour = difference.hour ?? 0
        let min =  (-1 * difference.minute!) ?? 0
        let sec = (-1 * difference.second!) ?? 0
        
        
        let status = String(min) + " minutes and " + String(sec) + " seconds away" ?? ""
        
        return status
    }
    
    
    func fetchStopMonitoring(monitoringRef: String, lineRef: String? = nil) {
        
        // start of fetching data
        isLoading = true
        // resets errorMessage everytime function is called
        errorMessage = nil
        
        let key = "test"
        let version = "2"
        let service = APIService()
        var url = URL(string: "")
        
        if let lineRef = lineRef {
            url = URL(string: "http://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)&LineRef=\(lineRef)")
        } else {
            url = URL(string: "http://bustime.mta.info/api/siri/stop-monitoring.json?key=\(key)&version=\(version)&MonitoringRef=\(monitoringRef)")
        }
        
//        fetchHelper(URL: url!)
        
        service.fetch(RawServerResponseStopMonitoring.self, url: url) { [unowned self] result in
            DispatchQueue.main.async {
                // indicate data request has completed
                self.isLoading = false

                // handle results
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                case .success(let data):
                    self.monitoredStop = data.Siri.ServiceDelivery.StopMonitoringDelivery![0].MonitoredStopVisit ?? []
                    self.isDone = true
                    print("Monitored stop:")
                }
            }
        }
    }
}
