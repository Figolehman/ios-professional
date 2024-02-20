//
//  PasswordStatusViewTests.swift
//  PasswordTests
//
//  Created by Figo Alessandro Lehman on 20/02/24.
//

import XCTest

@testable import Password

final class PasswordStatusViewTests_ShowCheckMarkOrReset_When_Validation_Is_Inline: XCTestCase {
    
    var statusView: PasswordStatusView!
    let validPassword = "12345678Aa!"
    let tooShort = "1234Aa!"

    override func setUp() {
        super.setUp()
        
        statusView = PasswordStatusView()
        statusView.shouldResetCriteria = true
    }
    
    func testValidPassword() throws {
        statusView.updateDisplay(validPassword)
        XCTAssertTrue(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isCheckMarkImage)
    }
    
    func testTooShort() throws {
        statusView.updateDisplay(tooShort)
        XCTAssertFalse(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isResetMarkImage)
    }
    
}

final class PasswordStatusViewTests_ShowCheckMarkOrXMark_When_Validation_Is_Loss_Of_Focus: XCTestCase {
    
    var statusView: PasswordStatusView!
    let validPassword = "12345678Aa!"
    let tooShort = "1234Aa!"

    override func setUp() {
        super.setUp()
        
        statusView = PasswordStatusView()
        statusView.shouldResetCriteria = false
    }
    
    func testValidPassword() throws {
        statusView.updateDisplay(validPassword)
        XCTAssertTrue(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isCheckMarkImage)
    }
    
    func testTooShort() throws {
        statusView.updateDisplay(tooShort)
        XCTAssertFalse(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isXMarkImage)
    }
    
}

final class PasswordStatusViewTests_CheckThreeOfFour_Other_CriteriaTests: XCTestCase {
    
    var statusView: PasswordStatusView!
    let twoMet = "PrabowoGibran"
    let threeMet = "Prabowo123Gibran"
    let fourMet = "@Prabowo123Gibran"
    
    override func setUp() {
        super.setUp()
        
        statusView = PasswordStatusView()
    }
    
    func testThreeCriteriaMet() throws {
        XCTAssertTrue(statusView.validate(threeMet))
    }
    
    func testTwoCriteriaMet() throws {
        XCTAssertFalse(statusView.validate(twoMet))
    }
    
    func testFourCriteriaMet() throws {
        XCTAssertTrue(statusView.validate(fourMet))
    }
    
}
