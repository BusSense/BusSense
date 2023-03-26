//
//  MTASIRI.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/19/23.
//

import Foundation

//struct RawServerResponseStopMonitoring: Codable {
//    let Siri: ServiceDeliveryResponse
//}
//
//struct ServiceDeliveryResponse: Codable {
//    let ServiceDelivery: DeliveryResponse
//}
//
//struct DeliveryResponse: Codable {
//    let ResponseTimestamp: String
//    let StopMonitoringDelivery: [StopVisits]
//}
//
//struct StopVisits: Codable {
//    let MonitoredStopVisit: VehicleJourneyResponse
//    let ResponseTimestamp: String
//    let ValidUntil: String
//}
//
//struct VehicleJourneyResponse: Codable {
//    let LineRef: String
//    let DirectionRef: String
//    let FramedVehicleJourneyRef: JourneyRefResponse
//    let JourneyPatternRef: String
//    let PublishedLineName: String
//    let OperatorRef: String
//    let OriginRef: String
//    let DestinationName: String
//    let OriginAimedDepartureTime: String
//    let Monitored: Bool
//    let VehicleLocation: Location
//    let Bearing: Double
//    let ProgressRate: String
//    let ProgressStatus: String
//    let BlockRef: String
//    let VehicleRef: String
//    let MonitoredCall: MonitoredCallResponse
//    let OnwardCalls: String
//}
//
//struct JourneyRefResponse: Codable {
//    let DataFrameRef: String
//    let DatedVehicleJourneyRef: String
//}
//
//struct Location: Codable {
//    let latitude: Double
//    let longitude: Double
//}
//
//struct MonitoredCallResponse: Codable {
//    let AimedArrivalTime: String
//    let ExpectedArrivalTime: String
//    let AimedDepartureTime: String
//    let ExpectedDepartureTime: String
//    let Extensions: ExtensionsResponse
//    let StopPointRef: String
//    let VisitNumber: Int
//    let StopPointName: String
//}
//
//struct ExtensionsResponse: Codable {
//    let Distances: Distance
//}
//
//struct Distance: Codable {
//    let PresentableDistance: String
//    let DistanceFromCall: Double
//    let StopsFromCall: Int
//    let CallDistanceAlongRoute: Double
//}


// MARK: - RawServerResponseStopMonitoring
struct RawServerResponseStopMonitoring: Codable {
    let siri: Siri

    enum CodingKeys: String, CodingKey {
        case siri = "Siri"
    }
}

// MARK: - Siri
struct Siri: Codable {
    let serviceDelivery: ServiceDelivery

    enum CodingKeys: String, CodingKey {
        case serviceDelivery = "ServiceDelivery"
    }
}

// MARK: - ServiceDelivery
struct ServiceDelivery: Codable {
    let responseTimestamp: String
    let stopMonitoringDelivery: [StopMonitoringDelivery]
    let situationExchangeDelivery: [SituationExchangeDelivery]

    enum CodingKeys: String, CodingKey {
        case responseTimestamp = "ResponseTimestamp"
        case stopMonitoringDelivery = "StopMonitoringDelivery"
        case situationExchangeDelivery = "SituationExchangeDelivery"
    }
}

// MARK: - SituationExchangeDelivery
struct SituationExchangeDelivery: Codable {
    let situations: Situations

    enum CodingKeys: String, CodingKey {
        case situations = "Situations"
    }
}

// MARK: - Situations
struct Situations: Codable {
    let ptSituationElement: [PtSituationElement]

    enum CodingKeys: String, CodingKey {
        case ptSituationElement = "PtSituationElement"
    }
}

// MARK: - PtSituationElement
struct PtSituationElement: Codable {
    let publicationWindow: PublicationWindow
    let severity: String
    let summary, description: [String]
    let affects: Affects
    let creationTime, situationNumber: String

    enum CodingKeys: String, CodingKey {
        case publicationWindow = "PublicationWindow"
        case severity = "Severity"
        case summary = "Summary"
        case description = "Description"
        case affects = "Affects"
        case creationTime = "CreationTime"
        case situationNumber = "SituationNumber"
    }
}

// MARK: - Affects
struct Affects: Codable {
    let vehicleJourneys: VehicleJourneys

    enum CodingKeys: String, CodingKey {
        case vehicleJourneys = "VehicleJourneys"
    }
}

// MARK: - VehicleJourneys
struct VehicleJourneys: Codable {
    let affectedVehicleJourney: [AffectedVehicleJourney]

    enum CodingKeys: String, CodingKey {
        case affectedVehicleJourney = "AffectedVehicleJourney"
    }
}

// MARK: - AffectedVehicleJourney
struct AffectedVehicleJourney: Codable {
    let lineRef, directionRef: String

    enum CodingKeys: String, CodingKey {
        case lineRef = "LineRef"
        case directionRef = "DirectionRef"
    }
}

// MARK: - PublicationWindow
struct PublicationWindow: Codable {
    let startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case startTime = "StartTime"
        case endTime = "EndTime"
    }
}

// MARK: - StopMonitoringDelivery
struct StopMonitoringDelivery: Codable {
    let monitoredStopVisit: [MonitoredStopVisit]
    let responseTimestamp, validUntil: String

    enum CodingKeys: String, CodingKey {
        case monitoredStopVisit = "MonitoredStopVisit"
        case responseTimestamp = "ResponseTimestamp"
        case validUntil = "ValidUntil"
    }
}

// MARK: - MonitoredStopVisit
struct MonitoredStopVisit: Codable {
    let monitoredVehicleJourney: MonitoredVehicleJourney
    let recordedAtTime: String

    enum CodingKeys: String, CodingKey {
        case monitoredVehicleJourney = "MonitoredVehicleJourney"
        case recordedAtTime = "RecordedAtTime"
    }
}

// MARK: - MonitoredVehicleJourney
struct MonitoredVehicleJourney: Codable {
    let lineRef, directionRef: String
    let framedVehicleJourneyRef: FramedVehicleJourneyRef
    let journeyPatternRef: String
    let publishedLineName: [String]
    let operatorRef, originRef, destinationRef: String
    let destinationName: String
    let monitored: Bool
    let vehicleLocation: VehicleLocation
    let bearing: Double
    let progressRate: String
    let blockRef: String?
    let vehicleRef: String
    let monitoredCall: MonitoredCall
    let originAimedDepartureTime: String?
    let progressStatus: [String]?

    enum CodingKeys: String, CodingKey {
        case lineRef = "LineRef"
        case directionRef = "DirectionRef"
        case framedVehicleJourneyRef = "FramedVehicleJourneyRef"
        case journeyPatternRef = "JourneyPatternRef"
        case publishedLineName = "PublishedLineName"
        case operatorRef = "OperatorRef"
        case originRef = "OriginRef"
        case destinationRef = "DestinationRef"
        case destinationName = "DestinationName"
        case monitored = "Monitored"
        case vehicleLocation = "VehicleLocation"
        case bearing = "Bearing"
        case progressRate = "ProgressRate"
        case blockRef = "BlockRef"
        case vehicleRef = "VehicleRef"
        case monitoredCall = "MonitoredCall"
        case originAimedDepartureTime = "OriginAimedDepartureTime"
        case progressStatus = "ProgressStatus"
    }
}

// MARK: - FramedVehicleJourneyRef
struct FramedVehicleJourneyRef: Codable {
    let dataFrameRef, datedVehicleJourneyRef: String

    enum CodingKeys: String, CodingKey {
        case dataFrameRef = "DataFrameRef"
        case datedVehicleJourneyRef = "DatedVehicleJourneyRef"
    }
}

// MARK: - MonitoredCall
struct MonitoredCall: Codable {
    let aimedArrivalTime: String
    let expectedArrivalTime: String?
    let arrivalProximityText: String
    let expectedDepartureTime: String?
    let distanceFromStop, numberOfStopsAway: Int
    let stopPointRef: String
    let visitNumber: Int
    let stopPointName: [String]

    enum CodingKeys: String, CodingKey {
        case aimedArrivalTime = "AimedArrivalTime"
        case expectedArrivalTime = "ExpectedArrivalTime"
        case arrivalProximityText = "ArrivalProximityText"
        case expectedDepartureTime = "ExpectedDepartureTime"
        case distanceFromStop = "DistanceFromStop"
        case numberOfStopsAway = "NumberOfStopsAway"
        case stopPointRef = "StopPointRef"
        case visitNumber = "VisitNumber"
        case stopPointName = "StopPointName"
    }
}

// MARK: - VehicleLocation
struct VehicleLocation: Codable {
    let longitude, latitude: Double

    enum CodingKeys: String, CodingKey {
        case longitude = "Longitude"
        case latitude = "Latitude"
    }
}


// MARK: - StopMonitoring
struct StopMonitoring: Codable {
    var monitoredStopVisit: [MonitoredStopVisit]

    init(from decoder: Decoder) throws {
        let rawResponse = try RawServerResponseStopMonitoring(from: decoder)
        
        monitoredStopVisit = rawResponse.siri.serviceDelivery.stopMonitoringDelivery[0].monitoredStopVisit
    }
}
