//
//  StringExtension.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
