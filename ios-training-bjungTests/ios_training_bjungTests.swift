//
//  ios_training_bjungTests.swift
//  ios-training-bjungTests
//
//  Created by 鄭 普勤 on 2023/11/29.
//

import XCTest
@testable import ios_training_bjung

final class WeatherModelMock: WeatherModelInput {
    
    private var resultWeather: String = "default"
    
    func fetchWeatherData() async throws -> String {
        return resultWeather
    }
    
    func fetchWeatherData(at location: String) async throws -> String {
        return resultWeather
    }
    
    func fetchWeatherData(request: WeatherRequest, completion: @escaping @Sendable @MainActor (WeatherResponse) -> ()) async throws {
        let response = WeatherResponse(
            minTemperature: 10,
            maxTemperature: 20,
            weatherCondition: resultWeather,
            date: Date()
        )
        await completion(response)
    }
    
    func setExpectedWeather(weather: WeatherCondition) {
        self.resultWeather = weather.rawValue
    }
}

final class HomePresenterMock: HomePresenterInput {
    
    private var resultWeather: String = "default"
    
    private weak var view: HomePresenterOutput?
    private var model: WeatherModelInput
    
    init(model: WeatherModelInput) {
        self.model = model
    }
    
    func inject(view: HomePresenterOutput) {
        self.view = view
    }
    
    func loadWeatherData() {
        let response = WeatherResponse(
            minTemperature: 10,
            maxTemperature: 20,
            weatherCondition: resultWeather,
            date: Date()
        )
        
        view?.updateDisplayScreen(updatedInfo: response)
    }
    
    func setExpectedWeather(weather: WeatherCondition) {
        self.resultWeather = weather.rawValue
    }
}



final class ios_training_bjungTests: XCTestCase {
    
    var homeViewController: HomeViewController!
    var mockPresenter: HomePresenterMock!
    var mockModel: WeatherModelMock!

    @MainActor
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
        self.mockModel = WeatherModelMock()
        self.mockPresenter = HomePresenterMock(model: mockModel)
        self.homeViewController = storyboard.instantiateViewController(identifier: "HomeView", creator: { coder in
            HomeViewController(coder: coder, presenter: self.mockPresenter)
        })
        self.mockPresenter.inject(view: self.homeViewController)
        homeViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testHomeViewLoadWeatherData() async throws {
        // Setup
        let testCases = [
            (weather: WeatherCondition.sunny, expect: UIImage(imageLiteralResourceName: "ic_sunny").withTintColor(.red)),
            (weather: WeatherCondition.cloudy, expect: UIImage(imageLiteralResourceName: "ic_cloudy").withTintColor(.gray)),
            (weather: WeatherCondition.rainy, expect: UIImage(imageLiteralResourceName: "ic_rainy").withTintColor(.systemBlue))
        ]
        
        // Exercise
        for testCase in testCases {
            self.mockPresenter.setExpectedWeather(weather: testCase.weather)
            homeViewController.loadWeatherData()
            
            // Verify
            XCTAssertEqual(homeViewController.imageView.image, testCase.expect)
        }
        
        // Verify
        XCTAssertEqual(homeViewController.minTemperatureLabel.text, "10")
        XCTAssertEqual(homeViewController.maxTemperatureLabel.text, "20")
    }
    
    func testMapperJsonEncoder() throws {
        // Setup
        var calendar = Calendar(identifier: .gregorian)
        // GitHub Actions でタイムゾーンを指定する必要がある
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let date = calendar.date(from: DateComponents(year: 2020, month: 4, day: 1, hour: 12, minute: 0, second: 0))!
        let target = WeatherRequest(area: "Tokyo", date: date)
        
        let expect = "{\"area\":\"Tokyo\",\"date\":\"2020-04-01T12:00:00+09:00\"}"
        
        // Exercise
        let result = try Mapper.encodeWeatherRequest(request: target)
        
        // Verify
        XCTAssertEqual(result, expect)
    }
    
    func testMapperJsonDecoder() throws {
        // Setup
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let date = calendar.date(from: DateComponents(year: 2020, month: 4, day: 1, hour: 12, minute: 0, second: 0))!
        let target = "{\"max_temperature\":25,\"date\":\"2020-04-01T12:00:00+09:00\",\"min_temperature\":7,\"weather_condition\":\"cloudy\"}"
        
        let expect = WeatherResponse(minTemperature: 7, maxTemperature: 25, weatherCondition: "cloudy", date: date)
        
        // Exercise
        let result = try Mapper.decodeWeatherResponse(json: target)
        
        // Verify
        XCTAssertEqual(result, expect)
    }
    
}
