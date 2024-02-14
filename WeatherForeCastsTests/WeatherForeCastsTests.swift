//
//  WeatherForeCastsTests.swift
//  WeatherForeCastsTests
//
//  Created by LinhMAC on 19/01/2024.
//

import XCTest
//@testable import WeatherForeCasts

final class WeatherForeCastsTests: XCTestCase {
//    class mockCheckValid: checkValid {
//        
//    }
//    var testValid : mockCheckValid!
//    override func setUp() {
//        super.setUp()
//        testValid = mockCheckValid()
//    }
//    
//    func testPasswordValidator() {
//        let (message1, valid1) = testValid.passwordValidator(password: "")
//        XCTAssertEqual(message1, "Password can't be empty.")
//        XCTAssertFalse(valid1)
//        
//        let (message2, valid2) = testValid.passwordValidator(password: "12345")
//        XCTAssertEqual(message2, "Password must be more than 6 digits.")
//        XCTAssertFalse(valid2)
//        
//        let (message3, valid3) = testValid.passwordValidator(password: "123456")
//        XCTAssertEqual(message3, "ok")
//        XCTAssertTrue(valid3)
//    }
//    
//    func testEmailValidator() {
//        let (message1, valid1) = testValid.emailValidator("")
//        XCTAssertEqual(message1, "Email can't be empty.")
//        XCTAssertFalse(valid1)
//        
//        let (message2, valid2) = testValid.emailValidator("invalidEmail")
//        XCTAssertEqual(message2, "The email is in the wrong format.")
//        XCTAssertFalse(valid2)
//        
//        let (message3, valid3) = testValid.emailValidator("validEmail@example.com")
//        XCTAssertEqual(message3, "ok")
//        XCTAssertTrue(valid3)
//    }
    
    
    
    func testAddition() {
        // Arrange
        let number1 = 3
        let number2 = 5
        
        // Act
        let result = addNumbers12(number1, number2)
        
        // Assert
        XCTAssertEqual(result, 8, "ket qua đúng là 8")
    }
    
    // Hàm tính tổng
    func addNumbers12(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
}
