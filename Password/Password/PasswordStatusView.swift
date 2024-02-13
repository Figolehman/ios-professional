//
//  CriteriaView.swift
//  Password
//
//  Created by Figo Alessandro Lehman on 13/02/24.
//

import UIKit

class PasswordStatusView: UIView {
    
//    let criterias: [UILabel] = Array(repeating: UILabel(), count: 5)
    
    let stackView = UIStackView()
    
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
//        stackView.backgroundColor = .systemCyan
        
    }
    
    func layout() {
        stackView.addArrangedSubview(PasswordCriteriaView(withCriteria: "Hello World!"))
        
        addSubview(stackView)
    }
}

