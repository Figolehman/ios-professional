//
//  CriteriaView.swift
//  Password
//
//  Created by Figo Alessandro Lehman on 13/02/24.
//

import UIKit

class PasswordStatusView: UIView {
    
    let lengthCriteriaView = PasswordCriteriaView(withCriteria: "8-32 characters (no spaces)")
    let upperCaseCriteriaView = PasswordCriteriaView(withCriteria: "uppercase letter (A-Z)")
    let lowerCaseCriteriaView = PasswordCriteriaView(withCriteria: "lowercase (a-z)")
    let digitCriteriaView = PasswordCriteriaView(withCriteria: "digit (0-9)")
    let specialCharacterCriteriaView = PasswordCriteriaView(withCriteria: "special character (e.g. !@#$%^)")
    
    let criteriaLabel = UILabel()
    
    let stackView = UIStackView()
    
    var shouldResetCriteria: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
    
}

extension PasswordStatusView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemFill
        
        lengthCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        upperCaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        lowerCaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        digitCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        specialCharacterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        
        criteriaLabel.translatesAutoresizingMaskIntoConstraints = false
        criteriaLabel.numberOfLines = 0
        criteriaLabel.attributedText = makeCriteriaMessage()

        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalCentering
//        stackView.backgroundColor = .systemCyan
        
    }
    
    func layout() {
//        stackView.addArrangedSubview(PasswordCriteriaView(withCriteria: "Hello World!"))
        stackView.addArrangedSubview(lengthCriteriaView)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(upperCaseCriteriaView)
        stackView.addArrangedSubview(lowerCaseCriteriaView)
        stackView.addArrangedSubview(digitCriteriaView)
        stackView.addArrangedSubview(specialCharacterCriteriaView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2)
        ])
    }
}

extension PasswordStatusView {
    private func makeCriteriaMessage() -> NSAttributedString {
        var plainTextAttributes = [NSAttributedString.Key : AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        var boldTextAttributes = [NSAttributedString.Key : AnyObject]()
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        boldTextAttributes[.foregroundColor] = UIColor.label
        
        let attrText = NSMutableAttributedString(string: "Use at least ", attributes: plainTextAttributes)
        attrText.append(NSMutableAttributedString(string: "3 of these 4 ", attributes: boldTextAttributes))
        attrText.append(NSMutableAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))
        
        return attrText
    }
}


extension PasswordStatusView {
    func updateDisplay(_ text: String) {
        let lengthAndNoSpaceMet = PasswordCriteria.lengthAndNoSpaceMet(text)
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)
        
        if shouldResetCriteria {
            lengthAndNoSpaceMet
            ? lengthCriteriaView.isCriteriaMet = true
            : lengthCriteriaView.reset()
            
            uppercaseMet
            ? upperCaseCriteriaView.isCriteriaMet = true
            : upperCaseCriteriaView.reset()
            
            lowercaseMet
            ? lowerCaseCriteriaView.isCriteriaMet = true
            : lowerCaseCriteriaView.reset()
            
            digitMet
            ? digitCriteriaView.isCriteriaMet = true
            : digitCriteriaView.reset()
            
            specialCharacterMet
            ? specialCharacterCriteriaView.isCriteriaMet = true
            : specialCharacterCriteriaView.reset()
        } else {
            lengthCriteriaView.isCriteriaMet = lengthAndNoSpaceMet
            upperCaseCriteriaView.isCriteriaMet = uppercaseMet
            lowerCaseCriteriaView.isCriteriaMet = lowercaseMet
            digitCriteriaView.isCriteriaMet = digitMet
            specialCharacterCriteriaView.isCriteriaMet = specialCharacterMet
        }
        
    }
    
    func validate(_ text: String) -> Bool{
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)
        
        let checkable = [uppercaseMet, lowercaseMet, digitMet, specialCharacterMet]
        let metCriteria = checkable.filter { $0 }.count
        let lengthAndNoSpaceMet = PasswordCriteria.lengthAndNoSpaceMet(text)
        
        if lengthAndNoSpaceMet && metCriteria >= 3 {
            return true
        }
        return false
    }
    
    func reset() {
        lengthCriteriaView.reset()
        digitCriteriaView.reset()
        upperCaseCriteriaView.reset()
        lowerCaseCriteriaView.reset()
        specialCharacterCriteriaView.reset()
    }
}
