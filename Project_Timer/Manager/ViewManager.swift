//
//  Manager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/17.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

struct ViewManager {
    
    func printTime(_ temp : Int) -> String {
        let S = temp%60
        let H = temp/3600
        let M = temp/60 - H*60
        
        let stringS = S<10 ? "0"+String(S) : String(S)
        let stringM = M<10 ? "0"+String(M) : String(M)
        
        let returnString  = String(H) + ":" + stringM + ":" + stringS
        return returnString
    }
}
