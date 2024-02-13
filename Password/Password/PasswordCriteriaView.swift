//
//  PasswordCriteriaView.swift
//  Password
//
//  Created by Figo Alessandro Lehman on 13/02/24.
//

import UIKit

class PasswordCriteriaView: UIView {
    
    let status = UIImageView()
    let criteria = UILabel()
    
    let stackView = UIStackView()
    
    let checkmarkImage = UIImage(systemName: "checkmark.circle")!.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    let xmarkImage = UIImage(systemName: "xmark.circle")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    let circleImage = UIImage(systemName: "circle")!.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
    
    var isCriteriaMet: Bool = false {
        didSet {
            if isCriteriaMet {
                status.image = checkmarkImage
            } else {
                status.image = xmarkImage
            }
        }
    }
    
    func reset() {
        isCriteriaMet = false
        status.image = circleImage
    }
    
    init(withCriteria criteria: String) {
        self.criteria.text = criteria
        
        super.init(frame: .zero)
        
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

extension PasswordCriteriaView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.image = circleImage
        
        criteria.translatesAutoresizingMaskIntoConstraints = false
        criteria.textColor = .secondaryLabel
        criteria.font = .preferredFont(forTextStyle: .subheadline)
        
        
    }
    
    func layout() {
        stackView.addArrangedSubview(status)
        stackView.addArrangedSubview(criteria)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
//            status.heightAnchor.constraint(equalTo: criteria.heightAnchor), 
            status.heightAnchor.constraint(equalTo: status.widthAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            status.leadingAnchor.constraint(equalTo: leadingAnchor),
//            status.topAnchor.constraint(equalTo: topAnchor),
//            status.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//        
//        NSLayoutConstraint.activate([
//            criteria.trailingAnchor.constraint(equalTo: trailingAnchor),
//            criteria.topAnchor.constraint(equalTo: topAnchor),
//            criteria.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
        
        // CHCR
        status.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        criteria.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
    }
}

