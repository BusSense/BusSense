//
//  MTAOBA.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/19/23.
//

import Foundation

struct RawServerResponseStopsForLocation: Codable {
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

struct StopsForLocation: Decodable {
    var responseCode: Int
    var busStops: [BusStop]
    var routes: [BusRoutes]

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStopsForLocation(from: decoder)
        
        responseCode = rawResponse.code
        busStops = rawResponse.data.busStop
        routes = rawResponse.data.references.routes
    }
}
