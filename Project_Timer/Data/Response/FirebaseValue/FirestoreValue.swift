//
//  FirestoreValue.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol FirestoreValue {}

extension FirebaseStringValue {
    var transString: FirebaseStringValue {
        let transString = self.value.replacingOccurrences(of: "\\n", with: "\n")
        return FirebaseStringValue(value: transString)
    }
}

extension FirebaseStringArrayValue {
    var transString: FirebaseStringArrayValue {
        let transStrings = self.arrayValue.values.map { $0.transString }
        return FirebaseStringArrayValue(arrayValue: .init(values: transStrings))
    }
}
