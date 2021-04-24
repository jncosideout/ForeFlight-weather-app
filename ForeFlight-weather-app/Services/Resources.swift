//
//  Resources.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/23/21.
//

import Foundation

//MARK: - Model-specific conformances
struct WeatherResource: APIResource {
    typealias ModelType = WeatherResponse
    let endpoint: String
    let host: String
    var customHeaders: [String:String] = [
        "ff-coding-exercise" : "1",
        "Content-Type" : "application/json",
        "accept" : "application/json"
    ]
    var queryItems: [URLQueryItem] = []

    init(endpoint: String, host: String, _ customHeaders: [String:String]? = nil) {
        self.endpoint = endpoint
        self.host = host
        if let custHeaders = customHeaders {
            for element in custHeaders {
                self.customHeaders[element.key] = element.value
            }
        }
    }
}
