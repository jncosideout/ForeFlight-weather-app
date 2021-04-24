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
        weatherServiceWorker.fetchWeather(forAirport: "kaus") { weatherResponse in
            guard let weatherResponse = weatherResponse else {
                XCTFail("Failed with nil weatherResponse")
                expectation.fulfill()
                return
            }

           // XCTAssertNotNil(weatherResponse.report.forecast.conditions.first?.period, "forecast condition first has no period")
            XCTAssertNotNil(weatherResponse.report.conditions.ident, "conditions.ident nil")

            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
