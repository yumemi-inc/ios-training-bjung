//
//  ios_training_bjungTests.swift
//  ios-training-bjungTests
//
//  Created by 鄭 普勤 on 2023/11/29.
//

import XCTest
import YumemiWeather
@testable import ios_training_bjung

class WeatherModelMock: WeatherModelInput {
    func fetchWeatherData() async throws -> String {
        return "sunny"
    }
    
    func fetchWeatherData(location: String) async throws -> String {
        return "sunny"
    }
    
    func fetchWeatherData(request: ios_training_bjung.WeatherRequest) async throws -> ios_training_bjung.WeatherResponse {
        return WeatherResponse(
            minTemperature: 10,
            maxTemperature: 20,
            weatherCondition: "sunny",
            date: Date()
        )
    }
}

final class ios_training_bjungTests: XCTestCase {
    
    var homeViewController: HomeViewController!
    var homePresenter: HomePresenter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
        let model = WeatherModelMock()
        self.homePresenter = HomePresenter(model: model)
        self.homeViewController = storyboard.instantiateViewController(identifier: "HomeView", creator: { coder in
            HomeViewController(coder: coder, presenter: self.homePresenter)
        })
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        homeViewController.loadViewIfNeeded()
        XCTAssertEqual(homeViewController.minTemperatureLabel.text, "--")
        
//        let task = Task {
//            homePresenter.loadWeatherData()
//        }
//        await task.value
        
        
        let expectation = self.expectation(description: "Async function completed")
        homeViewController.loadWeatherData { res in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
        
//        XCTAssertEqual(homeViewController.minTemperatureLabel.text, "10")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
