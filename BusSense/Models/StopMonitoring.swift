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
    let Siri: Siri

//    enum CodingKeys: String, CodingKey {
//        case Siri = "Siri"
//    }
}

// MARK: - Siri
struct Siri: Codable {
    let ServiceDelivery: ServiceDelivery

//    enum CodingKeys: String, CodingKey {
//        case ServiceDelivery = "ServiceDelivery"
//    }
}

// MARK: - ServiceDelivery
struct ServiceDelivery: Codable {
    let ResponseTimestamp: String
    let StopMonitoringDelivery: [StopMonitoringDelivery]?
    let SituationExchangeDelivery: [SituationExchangeDelivery]?

//    enum CodingKeys: String, CodingKey {
//        case responseTimestamp = "ResponseTimestamp"
//        case stopMonitoringDelivery = "StopMonitoringDelivery"
//        case situationExchangeDelivery = "SituationExchangeDelivery"
//    }
}

// MARK: - SituationExchangeDelivery
struct SituationExchangeDelivery: Codable {
    let Situations: Situations

//    enum CodingKeys: String, CodingKey {
//        case situations = "Situations"
//    }
}

// MARK: - Situations
struct Situations: Codable {
    let PtSituationElement: [PtSituationElement]

//    enum CodingKeys: String, CodingKey {
//        case ptSituationElement = "PtSituationElement"
//    }
}

// MARK: - PtSituationElement
struct PtSituationElement: Codable {
    let PublicationWindow: PublicationWindow
    let Severity: String
    let Summary, Description: [String]
    let Affects: Affects
    let CreationTime, SituationNumber: String

//    enum CodingKeys: String, CodingKey {
//        case publicationWindow = "PublicationWindow"
//        case severity = "Severity"
//        case summary = "Summary"
//        case description = "Description"
//        case affects = "Affects"
//        case creationTime = "CreationTime"
//        case situationNumber = "SituationNumber"
//    }
}

// MARK: - Affects
struct Affects: Codable {
    let VehicleJourneys: VehicleJourneys

//    enum CodingKeys: String, CodingKey {
//        case vehicleJourneys = "VehicleJourneys"
//    }
}

// MARK: - VehicleJourneys
struct VehicleJourneys: Codable {
    let AffectedVehicleJourney: [AffectedVehicleJourney]

//    enum CodingKeys: String, CodingKey {
//        case affectedVehicleJourney = "AffectedVehicleJourney"
//    }
}

// MARK: - AffectedVehicleJourney
struct AffectedVehicleJourney: Codable {
    let LineRef, DirectionRef: String

//    enum CodingKeys: String, CodingKey {
//        case lineRef = "LineRef"
//        case directionRef = "DirectionRef"
//    }
}

// MARK: - PublicationWindow
struct PublicationWindow: Codable {
    let StartTime, EndTime: String

//    enum CodingKeys: String, CodingKey {
//        case startTime = "StartTime"
//        case endTime = "EndTime"
//    }
}

// MARK: - StopMonitoringDelivery
struct StopMonitoringDelivery: Codable {
    let MonitoredStopVisit: [MonitoredStopVisit]?
    let ResponseTimestamp, ValidUntil: String

//    enum CodingKeys: String, CodingKey {
//        case monitoredStopVisit = "MonitoredStopVisit"
//        case responseTimestamp = "ResponseTimestamp"
//        case validUntil = "ValidUntil"
//    }
}

// MARK: - MonitoredStopVisit
struct MonitoredStopVisit: Codable {
    let MonitoredVehicleJourney: MonitoredVehicleJourney
    let RecordedAtTime: String

//    enum CodingKeys: String, CodingKey {
//        case monitoredVehicleJourney = "MonitoredVehicleJourney"
//        case recordedAtTime = "RecordedAtTime"
//    }
}

// MARK: - MonitoredVehicleJourney
struct MonitoredVehicleJourney: Codable {
    let LineRef, DirectionRef: String
    let FramedVehicleJourneyRef: FramedVehicleJourneyRef
    let JourneyPatternRef: String
    let PublishedLineName: [String]
    let OperatorRef, OriginRef, DestinationRef: String
    let DestinationName: [String]
    let Monitored: Bool
    let VehicleLocation: VehicleLocation
    let Bearing: Double
    let ProgressRate: String
    let BlockRef: String?
    let VehicleRef: String
    let MonitoredCall: MonitoredCall
    let OriginAimedDepartureTime: String?
    let ProgressStatus: [String]?

//    enum CodingKeys: String, CodingKey {
//        case LineRef = "LineRef"
//        case DirectionRef = "DirectionRef"
//        case FramedVehicleJourneyRef = "FramedVehicleJourneyRef"
//        case JourneyPatternRef = "JourneyPatternRef"
//        case PublishedLineName = "PublishedLineName"
//        case OperatorRef = "OperatorRef"
//        case OriginRef = "OriginRef"
//        case DestinationRef = "DestinationRef"
//        case DestinationName = "DestinationName"
//        case Monitored = "Monitored"
//        case VehicleLocation = "VehicleLocation"
//        case Bearing = "Bearing"
//        case ProgressRate = "ProgressRate"
//        case BlockRef = "BlockRef"
//        case VehicleRef = "VehicleRef"
//        case MonitoredCall = "MonitoredCall"
//        case OriginAimedDepartureTime = "OriginAimedDepartureTime"
//        case ProgressStatus = "ProgressStatus"
//    }
}

// MARK: - FramedVehicleJourneyRef
struct FramedVehicleJourneyRef: Codable {
    let DataFrameRef, DatedVehicleJourneyRef: String

//    enum CodingKeys: String, CodingKey {
//        case dataFrameRef = "DataFrameRef"
//        case datedVehicleJourneyRef = "DatedVehicleJourneyRef"
//    }
}

// MARK: - MonitoredCall
struct MonitoredCall: Codable {
    let AimedArrivalTime: String
    let ExpectedArrivalTime: String?
    let ArrivalProximityText: String
    let ExpectedDepartureTime: String?
    let DistanceFromStop, NumberOfStopsAway: Int
    let StopPointRef: String
    let VisitNumber: Int
    let StopPointName: [String]

//    enum CodingKeys: String, CodingKey {
//        case aimedArrivalTime = "AimedArrivalTime"
//        case expectedArrivalTime = "ExpectedArrivalTime"
//        case arrivalProximityText = "ArrivalProximityText"
//        case expectedDepartureTime = "ExpectedDepartureTime"
//        case distanceFromStop = "DistanceFromStop"
//        case numberOfStopsAway = "NumberOfStopsAway"
//        case stopPointRef = "StopPointRef"
//        case visitNumber = "VisitNumber"
//        case stopPointName = "StopPointName"
//    }
}

// MARK: - VehicleLocation
struct VehicleLocation: Codable {
    let Longitude, Latitude: Double

//    enum CodingKeys: String, CodingKey {
//        case longitude = "Longitude"
//        case latitude = "Latitude"
//    }
}


// MARK: - StopMonitoring
struct StopMonitoring: Codable {
    var  MonitoredStopVisit: [MonitoredStopVisit]

//    init(from decoder: Decoder) throws {
//        let rawResponse = try RawServerResponseStopMonitoring(from: decoder)
//        monitoredStopVisit = rawResponse.siri.serviceDelivery.stopMonitoringDelivery[0].monitoredStopVisit
//    }
}
