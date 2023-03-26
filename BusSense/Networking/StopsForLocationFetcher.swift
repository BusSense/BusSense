//
//  MTAOBAFetcher.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/19/23.
//

import Foundation

// needs to inherit ObservableObject to allow it to be used in UI
class StopsForLocationFetcher: ObservableObject {
    
    @Published var busStops: StopsForLocation? = nil
    @Published var isLoading: Bool = false
    @Published var hasFetchCompleted: Bool = false
    @Published var errorMessage: String? = nil
    
//    init() {
//        fetchAllBusStops()
//    }
    
    // TODO: - Add optional completion handler
    func fetchAllBusStops(lat: Double, lon: Double) {
        
        // start of fetching data
        isLoading = true
        hasFetchCompleted = false
        // resets errorMessage everytime function is called
        errorMessage = nil
        
        // TODO: - Set actual key in plist
        let key = "test"
        let version = "2"
        let radius = "10"        
        let service = APIService()
        let url = URL(string: "https://bustime.mta.info/api/where/stops-for-location.json?key=\(key)&version=\(version)&lat=\(lat)&lon=\(lon)&radius=\(radius)")
        
        service.fetch(StopsForLocation.self, url: url) { [unowned self] result in
            DispatchQueue.main.async {
                // indicate data request has completed
                self.isLoading = false
                self.hasFetchCompleted = true
                // handle results
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                case .success(let busStops):
                    self.busStops = busStops
                    print("bus stops:")
                    print(busStops)
                }
            }
        }
    }
}

//class StopsForLocationFetcher: ObservableObject {
//
//    @Published var busStops = [StopsForLocation]()
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//
////    int() {
////
////    }
//
//    func fetchBusStops(lat: Double, lon: Double) {
//        self.isLoading = true
//        let key: String = "test"
//        let url = URL(string: "http://bustime.mta.info/api/where/stops-for-location.json?key=\(key)&version=2&lat=\(lat)&lon=\(lon)&radius=10")!
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            self.isLoading = false
//
//            let decoder = JSONDecoder()
//            if let data = data {
//                do {
//                    let busStops = try decoder.decode([StopsForLocation].self, from: data)
//                    print(busStops)
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
//}
