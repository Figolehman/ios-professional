//
//  PasswordTextField.swift
//  Password
//
//  Created by Figo Alessandro Lehman on 12/02/24.
//

import UIKit

protocol PasswordTextFieldDelegate: AnyObject {
    func editingChanged(_ sender: PasswordTextField)
    func editingDidEnd(_ sender: PasswordTextField)
}

class PasswordTextField: UIView {
    
    typealias CustomValidation = (_ textValue: String?) -> (Bool, String)?
    
    let lockImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
    let textField = UITextField()
    let placeHolderText: String
    let eyeButton = UIButton(type: .custom)
    
    let dividerView = UIView()
    
    let errorLabel = UILabel()
    
    var customValidation: CustomValidation?
    
    weak var delegate: PasswordTextFieldDelegate?
    
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    init(placeholderText: String) {
        self.placeHolderText = placeholderText
        super.init(frame: .zero)

        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 60)
    }
    
}

extension PasswordTextField {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .systemOrange
        
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isSecureTextEntry = true
        textField.placeholder = placeHolderText
        textField.delegate = self
        textField.keyboardType = .asciiCapable
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .separator
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Your password must meet the requirements below."
        errorLabel.textColor = .systemRed
//        errorLabel.adjustsFontSizeToFitWidth = true
//        errorLabel.minimumScaleFactor = 0.8
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.isHidden = true
        errorLabel.font = .preferredFont(forTextStyle: .footnote)
        
    }
    
    func layout() {
        addSubview(lockImageView)
        addSubview(textField)
        addSubview(eyeButton)
        addSubview(dividerView)
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            lockImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            lockImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: lockImageView.trailingAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            eyeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            eyeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 1),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // CHCR
        lockImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        eyeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}


// MARK: - Target Actions
extension PasswordTextField {
    @objc func togglePasswordView(_ sender: UIButton) {
        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.editingChanged(self)
    }
}

// MARK: - UITextFieldDelegate
extension PasswordTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editingDidEnd(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("foo - textFieldShouldReturn")
        textField.endEditing(true)
        return true
    }
}

// MARK: - Validation
extension PasswordTextField {
    func validate() -> Bool {
        if let customValidation = customValidation,
           let customValidationResult = customValidation(text),
           customValidationResult.0 == false {
            showError(customValidationResult.1)
            return false
        }
        clearError()
        return true
    }
    
    private func showError(_ errorMessage: String) {
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
    }
    
    private func clearError() {
        errorLabel.isHidden = true
        errorLabel.text = ""
    }
}
