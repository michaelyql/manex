//
//  FormationGolfTrueBearingCommandHandler.swift
//  manex
//
//  Created by michaelyangqianlong on 3/6/23.
//

import SpriteKit

class FormationGolfTrueBearingHandler: FormationCommandHandler {
    
    let trueBrg: CGFloat
    let refShip: Warship
    let warships: [Warship]

    init(trueBrg: CGFloat, refShip: Warship, warships: [Warship]) {
        self.trueBrg = trueBrg
        self.refShip = refShip
        self.warships = warships
    }
    
    func execute() {
         
    }
}
