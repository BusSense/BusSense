//
//  MTAOBA.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/19/23.
//

import Foundation

// MARK: - RawServerResponseStopsForLocation
struct RawServerResponseStopsForLocation: Codable {
    let code: Int
    let currentTime: Int
    let data: DataResponse
    let text: String
    let version: Int
}

// MARK: - DataClass
struct DataResponse: Codable {
    let limitExceeded: Bool
    let busStop: [BusStop]
    let outOfRange: Bool
    let references: References
    
    enum CodingKeys: String, CodingKey {
        case limitExceeded, references, outOfRange
        case busStop = "list"
    }
}

// MARK: - List
struct BusStop: Codable {
    let code: String
    let direction: String
    let id: String
    let lat: Double
    let locationType: Int
    let lon: Double
    let name: String
    let routeIDS: [String]
    let wheelchairBoarding: String

    enum CodingKeys: String, CodingKey {
        case code, direction, id, lat, locationType, lon, name
        case routeIDS = "routeIds"
        case wheelchairBoarding
    }
}

// MARK: - References
struct References: Codable {
    let agencies: [Agency]
    let routes: [Route]
}

// MARK: - Agency
struct Agency: Codable {
    let disclaimer: String
    let id: String
    let lang: String
    let name: String
    let phone: String
    let privateService: Bool
    let timezone: String
    let url: String
}

// MARK: - Route
struct Route: Codable {
    let agencyID: String
    let color: String
    let description: String
    let id: String
    let longName, shortName, textColor: String
    let type: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case agencyID = "agencyId"
        case color, description, id, longName, shortName, textColor, type, url
    }
}

struct StopsForLocation: Codable {
    var responseCode: Int
    var busStops: [BusStop]
    var routes: [Route]
    var text: String

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStopsForLocation(from: decoder)
        
        responseCode = rawResponse.code
        busStops = rawResponse.data.busStop
        routes = rawResponse.data.references.routes
        text = rawResponse.text
    }
}
