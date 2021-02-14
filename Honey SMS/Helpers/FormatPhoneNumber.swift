//
//  FormatPhoneNumber.swift
//  Honey SMS
//
//  Created by Victor Vieira Veiga on 04/02/21.
//

import Foundation


extension String  {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
            var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            for index in 0 ..< pattern.count {
                guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(utf16Offset: index, in: self)
                let patternCharacter = pattern[stringIndex]
                guard patternCharacter != replacmentCharacter else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
            return pureNumber
        }
}
