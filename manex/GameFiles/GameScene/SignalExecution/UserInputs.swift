//
//  UserInputs.swift
//  manex
//
//  Created by michaelyangqianlong on 2/6/23.
//

import Foundation

protocol UserInputs {
    
}

struct FormationInputs: UserInputs {
    let isGolfSwitchOn: Bool
    let trueBrg: CGFloat?
    let relBrg: CGFloat?
    let relDir: Int
    let divSeparation: Int
}
