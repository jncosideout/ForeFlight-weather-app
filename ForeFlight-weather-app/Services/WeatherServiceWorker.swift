//
//  WeatherServiceWorker.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/23/21.
//

import Foundation

class WeatherServiceWorker {
    static let basePath = "qa.foreflight.com"
    var request: AnyObject?

    func fetchWeather(forAirport airport: String, completion: @escaping (WeatherResponse?) -> Void ) {
        let endpoint = "/weather/report/\(airport)"
        let weatherResource = WeatherResource(endpoint: endpoint, host: WeatherServiceWorker.basePath)
        let weatherRequest = APIRequest(resource: weatherResource)
        request = weatherRequest
        weatherRequest.load { result, error in
            if let error = error {
                print( "Error checking for weather update: \(error.localizedDescription)")
                completion(result)
            }

            if let result = result {
                print("got weather data")
                completion(result)
            }
        }
    }
}
