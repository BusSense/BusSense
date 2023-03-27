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
    
    func getDistanceAway() -> String{
        guard self.isDone && !monitoredStop.isEmpty else { return "no vehicles at this time"}
            // return distance first vehicle is away from stop
            return self
                .monitoredStop[0]
                .MonitoredVehicleJourney
                .MonitoredCall
                .ArrivalProximityText
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
