//
//  FormationTrueBearingCommandHandler.swift
//  manex
//
//  Created by michaelyangqianlong on 3/6/23.
//

import SpriteKit

class FormationTrueBearingCommandHandler: FormationCommandHandler {
    let trueBrg: CGFloat
    let refShip: Warship
    let warshipsArray: [Warship]

    init(trueBrg: CGFloat, refShip: Warship, warshipsArray: [Warship]) {
        self.trueBrg = trueBrg
        self.refShip = refShip
        self.warshipsArray = warshipsArray
    }
    
    func execute() {
        
    }
}
