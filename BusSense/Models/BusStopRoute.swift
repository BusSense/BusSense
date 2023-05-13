//
//  BusStopRoutes.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/25/23.
//

import Foundation

struct BusStopRoute: Codable {
    let code: String
    let id: String
    let name: String
    let direction: String
    let lat: Double
    let lon: Double
    let locationType: Int
    let routes: [RouteDetail]
//    let wheelchairBoarding: String
}

// static data for previews
extension BusStopRoute {
    static var sampleData: BusStopRoute = BusStopRoute(code:  "401447", id: "MTA_401447", name: "AMSTERDAM AV/W 131 ST", direction: "NE", lat: 40.816685, lon: -73.953761, locationType: 0, routes: [])
}

struct RouteDetail: Codable {
    let lineRef: String
    let directionRef: String
    let journeyPatternRef: String
    let publishedLineName: String
    let operatorRef: String
    let originRef: String
    let destinationRef: String
    let destinationName: String
    let lineNameAndDestinationName: String
}

// static data for previews
extension RouteDetail {
    static var sampleData: RouteDetail = RouteDetail(lineRef: "", directionRef: "", journeyPatternRef: "", publishedLineName: "", operatorRef: "", originRef: "", destinationRef: "", destinationName: "", lineNameAndDestinationName: "")
}
