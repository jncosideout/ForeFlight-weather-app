//
//  ForeFlight_weather_appTests.swift
//  ForeFlight-weather-appTests
//
//  Created by Alexander Scott Beaty on 4/23/21.
//

import XCTest
@testable import ForeFlight_weather_app

class ForeFlight_weather_appTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherService() {
        let expectation = self.expectation(description: "ForeFlight weather api download")

        let weatherServiceWorker = WeatherServiceWorker()
        weatherServiceWorker.fetchWeather(forAirport: "KBJJ") { weatherResponse in
            guard let weatherResponse = weatherResponse else {
                XCTFail("Failed with nil weatherResponse")
                expectation.fulfill()
                return
            }

            if let forecast = weatherResponse.report.forecast {
                if let forecastCondition1 = forecast.conditions.first {
                    XCTAssertNotNil(forecastCondition1.period, "forecast first condition has no period")
                } else {
                    XCTFail("forecast has no conditions array data")
                }
            } else {
                XCTFail("weatherResponse has no forecast")
            }
            XCTAssertNotNil(weatherResponse.report.conditions.ident, "conditions.ident nil")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testSaveAirportNames() {
        let airportsStore = AirportStore()
        airportsStore.allAirports.append("KBJJ")

        if airportsStore.saveAirports() {
            print("airport names saved")
        }

        let newAirportsStore = AirportStore()
        XCTAssert(newAirportsStore.allAirports.contains("KBJJ"), "airport names not saved")
    }
}
