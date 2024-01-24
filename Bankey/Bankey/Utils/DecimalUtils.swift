//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Figo Alessandro Lehman on 26/01/24.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
