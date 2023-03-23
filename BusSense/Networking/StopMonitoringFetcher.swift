//
//  MTASIRIFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/21/23.
//

import Foundation

// needs to inherit ObservableObject to allow it to be used in UI
class StopMonitoringFetcher: ObservableObject {
    
    @Published var monitoredStop = [StopMonitoring]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
//    init() {
//        fetchStopMonitoring()
//    }
    
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
        
        service.fetch([StopMonitoring].self, url: url) { [unowned self] result in
            DispatchQueue.main.async {
                // indicate data request has completed
                self.isLoading = false
                
                // handle results
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                case .success(let monitoredStop):
                    self.monitoredStop = monitoredStop
                    print("Monitored stop:")
                    print(monitoredStop)
                }
            }
        }
    }
}
