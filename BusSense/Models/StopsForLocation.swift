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
