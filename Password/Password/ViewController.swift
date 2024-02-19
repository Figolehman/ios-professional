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
        setupKeyboardHiding()
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .primaryActionTriggered)
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

// MARK: - Keyboard
extension ViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        // if textField bottom is below keybaord bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            
            view.frame.origin.y = newFrameY
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: - Actions
extension ViewController {
    
    @objc func resetPasswordButtonTapped(sender: UIButton) {
        view.endEditing(true)
        
        let isValidNewPassword = newPasswordTextField.validate()
        let isValidConfirmPassword = confirmPasswordTextField.validate()
        
        if isValidNewPassword && isValidConfirmPassword {
            showAlert(title: "Success", message: "You have successfully changed your password.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        alert.title = title
        alert.message = message
        present(alert, animated: true)
    }
}
