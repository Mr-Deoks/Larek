//
//  Day.swift
//  Larek
//
//  Created by Denis Aganin on 17.03.15.
//  Copyright (c) 2015 Denis Aganin. All rights reserved.
//

import Foundation
import UIKit


class Day {
    
    var time = Time.Morning
    var danger = Danger.Low
    var gopniks = 0
    var image = Time.Morning
    
}



enum Danger {
    
    case Low
    case Normal
    case High
    
    func dangerName() -> String {
        switch self {
        case .Low:
            return "Безопасно"
        case .Normal:
            return "Не очень"
        case .High:
            return "Высокая"
        }
    }
    func minGopnikLimit() -> Int {
        switch self {
        case .Low:
            return 1
        case .Normal:
            return 3
        case .High:
            return 5
        }
    }
    func maxGopnikLimit() -> Int {
        switch self {
        case .Low:
            return 5
        case .Normal:
            return 8
        case .High:
            return 18
        }    }
}



enum Time {
    
    case Morning
    case Day
    case Evening
    case Night
    
    func showTime() -> Int {
        switch self {
        case .Morning:
            return 10
        case .Day:
            return 15
        case .Evening:
            return 19
        case .Night:
            return 01
        }
    }
    func showImage() -> UIImage {
        switch self {
        case .Morning:
            return UIImage(named: "day.png")!
        case .Day:
            return UIImage(named: "day.png")!
        case .Evening:
            return UIImage(named: "night.png")!
        case .Night:
            return UIImage(named: "night.png")!
        }
    }
    func customerLimit() -> Int {
        switch self {
            case .Morning:
            return 20
            case .Day:
            return 35
            case .Evening:
            return 60
            case .Night:
            return 15
        }
    }
    func minCustomerLimit() -> Int {
        switch self {
        case .Morning:
            return 8
        case .Day:
            return 16
        case .Evening:
            return 32
        case .Night:
            return 7
        }
    }
}