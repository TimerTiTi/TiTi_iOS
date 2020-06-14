//
//  File.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/06/10.
//  Copyright © 2020 FDEE. All rights reserved.
//

import Foundation

public class TimeData
{
    var second : Int = 100
    var sum : Int = 0
    var allTime : Int = 28800
    
    func getSecond() -> Int {
        return second
    }
    func getSum() -> Int {
        return sum
    }
    func getAllTime() -> Int {
        return allTime
    }
    
    func setSecond(s : Int)
    {
        second = s
    }
    func setSum(s : Int)
    {
        sum = s
    }
    func setTime(t : Int)
    {
        allTime = t
    }
}
