//
//  WeatherForeCastsTests.swift
//  WeatherForeCastsTests
//
//  Created by LinhMAC on 19/01/2024.
//

import XCTest
@testable import WeatherForeCasts

final class WeatherForeCastsTests: XCTestCase {
    
    func validatorInformTestCase() {
//        XCTAssertFalse(test())
    }
    func test(){
        let email = "linhlinh"
        let password = "123"
        let testvalidator = EmailValidater.emailValidator(email).valid
//        return testvalidator
        XCTAssertFalse(testvalidator)
    }

    func testAddition() {
        // Arrange
        let number1 = 3
        let number2 = 5
        
        // Act
        let result = addNumbers12(number1, number2)
        
        // Assert
        XCTAssertEqual(result, 8, "Addition result should be 8")
    }
    
    // Hàm tính tổng
    func addNumbers12(_ a: Int, _ b: Int) -> Int {
        return a + b
    }

}
