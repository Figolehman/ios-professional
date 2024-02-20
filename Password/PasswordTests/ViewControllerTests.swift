//
//  ViewControllerTests.swift
//  PasswordTests
//
//  Created by Figo Alessandro Lehman on 20/02/24.
//

import XCTest

@testable import Password

final class ViewControllerTests_NewPassword_Validation: XCTestCase {

    var vc: ViewController!
    let validPassword = "12345678Aa!"
    let tooShort = "1234Aa!"
    
    override func setUp() {
        super.setUp()
        
        vc = ViewController()
        
    }
    
    func testEmptyPassword() throws {
        vc.passwordText = ""
        vc.resetPasswordButtonTapped(sender: vc.resetButton)
        XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "Enter your password")
    }
    
    func testInvalidPassword() throws {
        vc.passwordText = "😠"
        vc.resetPasswordButtonTapped(sender: vc.resetButton)
        XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "Enter valid special chars (./@:?!()$\\/#) with no spaces")
    }
    
    func testCriteriaNotMet() throws {
        vc.passwordText = tooShort
        vc.resetPasswordButtonTapped(sender: vc.resetButton)
        XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "Your password must meet the requirements below")
    }
    
    func testValidPassword() throws {
        vc.passwordText = validPassword
        vc.resetPasswordButtonTapped(sender: vc.resetButton)
        XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "")
    }
}

final class ViewControllerTests_ConfirmPassword_Validation: XCTestCase {
    
    var vc: ViewController!
    let validPassword = "PrabowoGibran123@"
    
    override func setUp() {
        super.setUp()
        
        vc = ViewController()
    }
    
    func testEmptyPassword() throws {
        vc.confirmPasswordTextField.text = ""
        vc.resetPasswordButtonTapped(sender: vc.resetButton)
        
        XCTAssertEqual(vc.confirmPasswordTextField.errorLabel.text!, "Enter your password.")
    }
    
    func testPasswordDoNotMatch() throws {
        vc.newPasswordTextField.text = validPassword
        vc.confirmPasswordTextField.text = "Prabooo123@"
        vc.resetPasswordButtonTapped(sender: vc.resetButton)
        
        XCTAssertEqual(vc.confirmPasswordTextField.errorLabel.text!, "Passwords do not match.")
    }
    
    func testPasswordMatch() throws {
        vc.passwordText = validPassword
        vc.resetPasswordButtonTapped(sender: vc.resetButton)
        
        XCTAssertEqual(vc.confirmPasswordTextField.errorLabel.text, "")
    }
}

final class ViewControllerTests_Show_Alert: XCTestCase {

    var vc: ViewController!
    let validPassword = "12345678Aa!"
    let tooShort = "1234Aa!"
    
    override func setUp() {
        super.setUp()
        vc = ViewController()
    }
    
    func testShowSuccess() throws {
        vc.passwordText = validPassword
        vc.resetPasswordButtonTapped(sender: UIButton())

        XCTAssertNotNil(vc.alert)
        XCTAssertEqual(vc.alert!.title, "Success") // Optional
    }

    func testShowError() throws {
        vc.newPasswordTextField.text = validPassword
        vc.confirmPasswordTextField.text = tooShort
        vc.resetPasswordButtonTapped(sender: UIButton())

        XCTAssertNil(vc.alert)
    }
}
