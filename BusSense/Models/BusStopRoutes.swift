//
//  BusStopRoutes.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/25/23.
//

import Foundation

struct BusStopRoutes {
    let code: String
    let id: String
    let name: String
    let direction: String
    let lat: Double
    let lon: Double
    let locationType: Int
    let routes: [RouteDetail]
    let wheelchairBoarding: String
}

struct RouteDetail {
    let lineRef: String
    let directionRef: String
    let journeyPatternRef: String
    let publishedLineName: String
    let operatorRef: String
    let originRef: String
    let destinationRef: String
    let destinationName: String
}
