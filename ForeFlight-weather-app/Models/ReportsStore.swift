//
//  ReportsStore.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/25/21.
//

import Foundation

class ReportsStore {
    var allReports: [WeatherResponse.Report] = []

    func getReport(for airport: String) -> WeatherResponse.Report? {
        let airportLower = airport.lowercased()
        let report = allReports.first(where: { $0.forecast?.ident == airportLower })
        return report
    }

    func removeReport(for airport: String) {
        let airportLower = airport.lowercased()
        if let index = allReports.firstIndex(where: { $0.forecast?.ident == airportLower }) {
            allReports.remove(at: index)
        }
    }

    func addReport(_ report: WeatherResponse.Report) {
        removeReport(for: report.forecast?.ident ?? "")
        allReports.append(report)
    }

    func updateReport(for airport: String) {
        removeReport(for: airport)
        let weatherService = WeatherServiceWorker()
        weatherService.fetchWeather(forAirport: airport) { weatherResponse in
            if let report = weatherResponse?.report {
                self.addReport(report)
                print("report for \(airport) updated at \(Date(timeIntervalSinceNow: 0))")
            }
        }
    }
}
