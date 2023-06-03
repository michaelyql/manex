//
//  FormationTrueBearingWithDivHandler.swift
//  manex
//
//  Created by michaelyangqianlong on 3/6/23.
//

import SpriteKit

class FormationTrueBearingWithDivHandler: FormationCommandHandler {
    let trueBrg: CGFloat
    let refShip: Warship
    
    init(trueBrg: CGFloat, refShip: Warship) {
        self.trueBrg = trueBrg
        self.refShip = refShip
    }
    
    func execute() {
        
    }
}
