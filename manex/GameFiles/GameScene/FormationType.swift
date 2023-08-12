//
//  FormationType.swift
//  manex
//
//  Created by Michael Yang Qianlong on 3/8/23.
//

import Foundation

enum FormationType: Equatable, CustomStringConvertible {
    
    var description: String {
        get {
            switch self {
            case .one:     return "1"
            case .two:     return "2"
            case .three:   return "3"
            case .four:    return "4"
            case .five:    return "5"
            case .six:     return "6"
            case .seven:   return "7"
            case .eight:   return "8"
            case .nine:    return "9"
            case .ten:     return "10"
            case .eleven:  return "11"
            case .twelve:  return "12"
            case .lineOfBearing(let brg): return "Line of Brg \(brg)"
            case .none:    return "None"
            }
        }
    }
    
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case eleven
    case twelve
    case lineOfBearing(CGFloat)
    case none
    
    init(index: Int) {
        switch index {
        case 1:
            self = .one
        case 2:
            self = .two
        case 3:
            self = .three
        case 4:
            self = .four
        case 5:
            self = .five
        case 6:
            self = .six
        case 7:
            self = .seven
        case 8:
            self = .eight
        case 9:
            self = .nine
        case 10:
            self = .ten
        case 11:
            self = .eleven
        case 12:
            self = .twelve
        default:
            self = .none
        }
    }
    
    init(bearing: CGFloat) {
        self = .lineOfBearing(bearing)
    }
}
