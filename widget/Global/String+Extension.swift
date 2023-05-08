//
//  String+Extension.swift
//  widgetExtension
//
//  Created by Kang Minsang on 2023/05/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
