//
//  MTAOBA.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/19/23.
//

import Foundation


// Stop-For-Location JSON

struct RawServerResponseStopsForLocation: Codable {
    let code: Int
    let currentTime: Int
    let data: DataResponse
    let text: String
    let version: Int
}

struct DataResponse: Codable {
        let limitExceeded: Bool
        let stops: [BusStop]
//        let references: ReferencesStruct
    
//    enum CodingKeys: String, CodingKey {
////        case limitExceeded, references
//        case limitExceeded
//        case stops = "list"
//    }
}

struct BusStop: Codable {
    let code: String
    let direction: String
    let id: String
    let lat: Double
    let locationType: Int
    let lon: Double
    let name: String
    let routes: [BusRoutes]
    let wheelchairBoarding: String
}

// static data for previews
extension BusStop {
    static var sampleData: BusStop = BusStop(code:  "401447", direction: "NE", id: "MTA_401447", lat: 40.816685, locationType: 0, lon: -73.953761, name: "AMSTERDAM AV/W 131 ST", routes: [], wheelchairBoarding: "UNKNOWN")
}

//struct ReferencesStruct: Codable {
//    let routes: [BusRoutes]
//}

struct BusRoutes: Codable {
    var agency: Agency
    var color: String = ""
    var description: String = ""
    var id: String = ""
    var longName: String = ""
    var shortName: String = ""
    var textColor: String = ""
    var type: Int = 1
    var url: String = ""
}

// static data for previews
extension BusRoutes {
    static var sampleData: BusRoutes = BusRoutes(agency: Agency(), color: "blue", description: "", id: "", longName: "", shortName: "", textColor: "")
}

struct Agency: Codable {
    var disclaimer: String = ""
    var email: String = ""
    var fareUrl: String = ""
    var id: String = ""
    var lang: String = ""
    var name: String = ""
    var phone: String = ""
    var privateService: Bool = false
    var timezone: String = ""
    var url: String = ""
}

struct StopsForLocation: Decodable {
    var responseCode: Int
    var busStops: [BusStop]
    var routes: [BusRoutes]

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStopsForLocation(from: decoder)
        
        responseCode = rawResponse.code
        busStops = rawResponse.data.stops
        routes = rawResponse.data.stops[0].routes
//        routes = rawResponse.data.references.routes
    }
}
