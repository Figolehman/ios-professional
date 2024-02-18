//
//  ViewController.swift
//  Password
//
//  Created by Figo Alessandro Lehman on 08/02/24.
//

import UIKit

class ViewController: UIViewController {
    
    typealias CustomValidation = PasswordTextField.CustomValidation
    
    let stackView = UIStackView()
    
    let newPasswordTextField = PasswordTextField(placeholderText: "New Password")
    
    let passwordStatusView = PasswordStatusView()
    
    let confirmPasswordTextField = PasswordTextField(placeholderText: "Re-enter new password")
    
    let resetButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}

extension ViewController {
    
    func setup() {
        setupNewPassword()
        setupConfirmPassword()
        setupDismissKeyboardGesture()
    }
    
    private func setupNewPassword() {
        let newPasswordValidation: CustomValidation = { text in
            
            // Empty Text
            guard let text = text, !text.isEmpty else {
                self.passwordStatusView.reset()
                return(false, "Enter your password")
            }
            
            // Valid Characters
            let validSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/#"
            let invalidSet = CharacterSet(charactersIn: validSet).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                self.passwordStatusView.reset()
                return (false, "Enter valid special chars (./@:?!()$\\/#) with no spaces")
            }
            
            // Criteria met
            self.passwordStatusView.updateDisplay(text)
            if !self.passwordStatusView.validate(text) {
                return (false, "Your password must meet the requirements below")
            }
            
            
            return (true, "")
        }
        
        newPasswordTextField.customValidation = newPasswordValidation
        newPasswordTextField.delegate = self
    }
    
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func setupConfirmPassword() {
        let confirmPasswordValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password.")
            }
            
            guard text == self.newPasswordTextField.text else {
                return (false, "Passwords do not match")
            }
            
            return (true, "")
        }
        
        confirmPasswordTextField.customValidation = confirmPasswordValidation
        confirmPasswordTextField.delegate = self
    }
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordStatusView.translatesAutoresizingMaskIntoConstraints = false
        passwordStatusView.layer.cornerRadius = 5
        passwordStatusView.clipsToBounds = true
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.configuration = .filled()
        resetButton.setTitle("Reset password", for: [])
//        resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(passwordStatusView)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(resetButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2)
        ])
    }
}

// MARK: - PasswordTextFieldDelegate
extension ViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordTextField) {
        if sender === newPasswordTextField {
            passwordStatusView.updateDisplay(sender.textField.text ?? "")
        }
    }
    
    func editingDidEnd(_ sender: PasswordTextField) {
        if sender === newPasswordTextField {
            passwordStatusView.shouldResetCriteria = false
            _ = newPasswordTextField.validate()
        } else if sender === confirmPasswordTextField {
            _ = confirmPasswordTextField.validate()
        }
    }
}
