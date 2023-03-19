//
//  APIManager.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/19/23.
//

import Foundation
//import CoreLocation

struct RawServerResponse: Codable {
    let code: Int
    let data: DataResponse
}

struct DataResponse: Codable {
        let limitExceeded: Bool
        let busStop: [BusStop]
        let references: ReferencesStruct
    
    enum CodingKeys: String, CodingKey {
        case limitExceeded, references
        case busStop = "list"
    }
}

struct BusStop: Codable {
    let code: String
    let id: String
    let name: String
    let direction: String
    let lat: Double
    let lon: Double
    let locationType: Int
    let routeIds: [String]
    let wheelchairBoarding: String
}

struct ReferencesStruct: Codable {
    let routes: [BusRoutes]
}

struct BusRoutes: Codable {
    let agencyId: String
    let color: String
    let description: String
    let id: String
    let longName: String
    let shortName: String
    let textColor: String
    let type: Int
}

struct ServerResponse: Decodable {
    var responseCode: Int
    var busStops: [BusStop]
    var routes: [BusRoutes]

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponse(from: decoder)
        
        // Now you can pick items that are important to your data model,
        // conveniently decoded into a Swift structure
        responseCode = rawResponse.code
        //stopCode = rawResponse.data
        busStops = rawResponse.data.busStop
        routes = rawResponse.data.references.routes
    }
}

struct RawServerResponseSIRI: Codable {
    let Siri: Siri
}

struct Siri: Codable {
    let ServiceDelivery: ServiceDelivery
}

struct ServiceDelivery: Codable {
    let StopMonitoringDelivery: [StopMonitoringDelivery]
}

struct StopMonitoringDelivery: Codable {
    let MonitoredStopVisit: [MonitoredStopVisit]
}

struct MonitoredStopVisit: Codable {
    let MonitoredVehicleJourney: MonitoredVehicleJourney
}

struct MonitoredVehicleJourney: Codable {
    let LineRef: String
    let DirectionRef: String
    let JourneyPatternRef: String
    let PublishedLineName: [String]
    let OriginRef: String
    let DestinationRef: String
    let DestinationName: [String]
    let Monitored: Bool
    let VehicleLocation: Coordinates
    let Bearing: Double
    let VehicleRef: String
    let MonitoredCall: MonitoredCall
}

struct Coordinates: Codable {
    let Longitude: Double
    let Latitude: Double
}

struct MonitoredCall: Codable {
    let AimedArrivalTime: String
    let ExpectedArrivalTime: String
    let ArrivalProximityText: String
    let ExpectedDepartureTime: String
    let DistanceFromStop: Int
    let NumberOfStopsAway: Int
    let StopPointRef: String
    let VisitNumber: Int
    let StopPointName: [String]
}

struct ServerResponseSIRI: Codable {
    var monitoredStopVisit: [MonitoredStopVisit]

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseSIRI(from: decoder)
        
        // Now you can pick items that are important to your data model,
        // conveniently decoded into a Swift structure
        monitoredStopVisit = rawResponse.Siri.ServiceDelivery.StopMonitoringDelivery[0].MonitoredStopVisit
    }
}

// MARK: - Code from swift playrgound

//let jsonData = JSONBus.data(using: .utf8)!
//
////let response = try! JSONDecoder().decode(RawServerResponse.self, from: jsonData)
////print(response.data.list[0].code)
//
//do {
////    let response = try JSONDecoder().decode(ServerResponse.self, from: jsonData)
////    // if (response.)
////    if (response.busStops.isEmpty) {
////        print("No bus stop nearby.")
//    let response = try JSONDecoder().decode(RawServerResponseSIRI.self, from: jsonData)
//        // if (response.)
//    if (false) {
//            print("Empty.")
//    } else {
////        print("bus stops:")
////        for busStop in response.busStops {
////            print(busStop.id)
////            print(busStop.name)
////            print(busStop.direction)
////            print(busStop.lat)
////            print(busStop.lon)
////            print(busStop.routeIds)
////            print()
////        }
////
////        print()
////        print("bus routes:")
////        for route in response.routes {
////            print(route.description)
////            print(route.id)
////            print(route.longName)
////            print(route.shortName)
////            print()
////        }
//
////        for stopVisit in response.monitoredStopVisit {
////            print(stopVisit)
////        }
//
//        print(response)
//    }
//    //print(response.busStops[0].code)
//} catch {
//    print(error)
//}

//class APIManager {
//
//    static let shared = APIManager()
//    private let baseUrl = "https://example.com/api/"
//
//    func fetchNearestStops(latitude: Double, longitude: Double, completion: @escaping ([Station]?, Error?) -> Void) {
//        let urlString = baseUrl + "stations?latitude=\(latitude)&longitude=\(longitude)"
//        guard let url = URL(string: urlString) else {
//            completion(nil, APIError.invalidUrl)
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            guard let data = data else {
//                completion(nil, APIError.noData)
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let stationsResponse = try decoder.decode(StationsResponse.self, from: data)
//                let stations = stationsResponse.data.list
//                completion(stations, nil)
//            } catch {
//                completion(nil, error)
//            }
//        }.resume()
//    }
//}

class APIManager {
//    func fetchStops(at location: CLLocation, completion: @escaping ([Stop]) -> ()) {
//        // use location to build API request
//        let requestURL = URL(string: "https://example.com/api/stops?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)")!
//
//        // make API call and parse response data
//        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print("Error fetching stops: \(error?.localizedDescription ?? "Unknown error")")
//                completion([])
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(Response.self, from: data)
//                completion(response.data.list)
//            } catch {
//                print("Error decoding response: \(error.localizedDescription)")
//                completion([])
//            }
//        }.resume()
//    }
}


//enum APIError: Error {
//    case invalidUrl
//    case noData
//}
