//
//  String+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

extension String {
    static let currentVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static var userTintColor: String {
        let colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        return "D\(colorIndex)"
    }
    /// 디바이스 언어별로 번역기능을 위한 함수, Localizable 파일 내 String 값에 해당되는 언어값 반환
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
    
    func localizedForNewFeatures(input: String) -> String {
        let localilzedString = NSLocalizedString(self, tableName: "newFeatures" , value: "\(self)", comment: "")
        let localizedInput = NSLocalizedString(input, tableName: "newFeatures" , value: "\(input)", comment: "")
        return localilzedString.replacingOccurrences(of: "*", with: localizedInput)
    }
    
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}
