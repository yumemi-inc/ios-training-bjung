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
    private var resultWeather: String = "default"
    
    func fetchWeatherData() async throws -> String {
        return resultWeather
    }
    
    func fetchWeatherData(at location: String) async throws -> String {
        return resultWeather
    }
    
    func fetchWeatherData(request: ios_training_bjung.WeatherRequest) async throws -> ios_training_bjung.WeatherResponse {
        return WeatherResponse(
            minTemperature: 10,
            maxTemperature: 20,
            weatherCondition: resultWeather,
            date: Date()
        )
    }
    
    func setExpectedWeather(weather: String) {
        self.resultWeather = weather
    }
}

final class ios_training_bjungTests: XCTestCase {
    
    var homeViewController: HomeViewController!
    var homePresenter: HomePresenter!
    var mockModel: WeatherModelMock!

    @MainActor
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
        self.mockModel = WeatherModelMock()
        self.homePresenter = HomePresenter(model: mockModel)
        self.homeViewController = storyboard.instantiateViewController(identifier: "HomeView", creator: { coder in
            HomeViewController(coder: coder, presenter: self.homePresenter)
        })
        self.homePresenter.inject(view: self.homeViewController)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testHomeViewLoadWeatherData() async throws {
        // Setup
        homeViewController.loadViewIfNeeded()
        let testCases = [
            (weather: "sunny", expect: UIImage(imageLiteralResourceName: "ic_sunny").withTintColor(.red)),
            (weather: "cloudy", expect: UIImage(imageLiteralResourceName: "ic_cloudy").withTintColor(.gray)),
            (weather: "rainy", expect: UIImage(imageLiteralResourceName: "ic_rainy").withTintColor(.systemBlue))
        ]
        
        // Exercise
        for testCase in testCases {
            self.mockModel.setExpectedWeather(weather: testCase.weather)
            await homeViewController.loadWeatherData()
            
            // Verify
            XCTAssertEqual(homeViewController.imageView.image, testCase.expect)
        }
        
        // Verify
        XCTAssertEqual(homeViewController.minTemperatureLabel.text, "10")
        XCTAssertEqual(homeViewController.maxTemperatureLabel.text, "20")
    }
    
    func testMapperJsonEncoder() throws {
        // Setup
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 2020, month: 4, day: 1, hour: 12, minute: 0, second: 0))!
        let target = WeatherRequest(area: "Tokyo", date: date)
        
        let expect = "{\"area\":\"Tokyo\",\"date\":\"2020-04-01T12:00:00+09:00\"}"
        
        // Exercise
        let result = try Mapper.encodeWeatherRequest(request: target)
        
        // Verify
        XCTAssertEqual(result, expect)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
