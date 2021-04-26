//
//  WeatherResponse.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/23/21.
//

import Foundation

struct WeatherResponse: Codable {

    let report: Report

    struct Report: Codable {
        let conditions: Conditions
        let forecast: Forecast?

        struct Conditions: Codable {
            let text: String
            let ident: String?
            let dateIssued: String
            let lat: Double
            let lon: Double
            let elevationFt: Double
            let tempC: Double?
            let dewpointC: Double?
            let pressureHg: Double?
            let densityAltitudeFt: Int?
            let relativeHumidity: Int
            let flightRules: String
            let cloudLayers: [CloudLayers]
            let visibility: Visibility
            let wind: Wind
            let period: Forecast.Period?

            struct CloudLayers: Codable {
                let coverage: String?
                let altitudeFt: Double?
                let ceiling: Bool?
            }

            struct Visibility: Codable {
                let distanceSm: Double?
                let prevailingVisSm: Double?
                let distanceQualifier: Int?
                let prevailingVisDistanceQualifie: Int?
            }

            struct Wind: Codable {
                let speedKts: Double?
                let direction: Int?
                let from: Int?
                let variable: Bool?
            }
        }

        struct Forecast: Codable {
            let text: String
            let ident: String
            let dateIssued: String?
            let period: Period
            let lat: Double
            let lon: Double
            let elevationFt: Double
            let conditions: [Conditions]

            struct Period: Codable {
                let dateStart: String?
                let dateEnd: String?
            }
        }
    }
}
