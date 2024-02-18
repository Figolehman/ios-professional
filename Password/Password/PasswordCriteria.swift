//
//  PasswordCriteria.swift
//  Password
//
//  Created by Figo Alessandro Lehman on 18/02/24.
//

import Foundation

struct PasswordCriteria {
    static func lengthCriteriaMet(_ text: String) -> Bool {
        return text.count >= 8 && text.count <= 32
    }
    
    static func noSpaceCriteriaMet(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
    
    static func lengthAndNoSpaceMet(_ text: String) -> Bool {
        return lengthCriteriaMet(text) && noSpaceCriteriaMet(text)
    }
    
    static func uppercaseMet(_ text: String) -> Bool {
        return text.range(of: "[A-Z]", options: .regularExpression) != nil
    }
    
    static func lowercaseMet(_ text: String) -> Bool {
        return text.range(of: "[a-z]", options: .regularExpression) != nil
    }
    
    static func digitMet(_ text: String) -> Bool {
        return text.range(of: "[0-9]", options: .regularExpression) != nil
    }
    
    static func specialCharacterMet(_ text: String) -> Bool {
        return text.range(of: "[^A-Za-z0-9 ]", options: .regularExpression) != nil
//        return text.range(of: "[@:?!()$#,./\\\\]", options: .regularExpression) != nil
    }
}
