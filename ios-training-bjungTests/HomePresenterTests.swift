//
//  HomePresenterTests.swift
//  ios-training-bjungTests
//
//  Created by 鄭 普勤 on 2024/01/15.
//

import XCTest
@testable import ios_training_bjung

final class HomeViewMock: HomePresenterOutput {
    
    var expectation: XCTestExpectation?
    
    func showLoadingUI() {
        
    }
    
    func updateDisplayScreen(updatedInfo response: ios_training_bjung.WeatherResponse) {
        expectation?.fulfill()
    }
    
    func showAlertControllerByError(title: String, message: String) {
        
    }
    
}

final class HomePresenterTests: XCTestCase {
    
    var homePresenter: HomePresenter!
    var mockModel: WeatherModelMock!
    var mockView: HomeViewMock!

    @MainActor
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mockModel = WeatherModelMock()
        self.homePresenter = HomePresenter(model: mockModel)
        self.mockView = HomeViewMock()
        self.homePresenter.inject(view: mockView)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testHomePresenterLoadWeatherData() throws {
        // Setup
        let expectation = XCTestExpectation(description: "method Called")
        mockView.expectation = expectation
        
        // Exercise
        homePresenter.loadWeatherData()
        
        // Verify
        wait(for: [expectation], timeout: 10.0)
    }

}
