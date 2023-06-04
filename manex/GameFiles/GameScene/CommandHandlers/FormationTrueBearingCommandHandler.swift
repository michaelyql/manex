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
    let warships: [Warship]

    init(trueBrg: CGFloat, refShip: Warship, warships: [Warship]) {
        self.trueBrg = trueBrg
        self.refShip = refShip
        self.warships = warships
    }
    
    func execute() {
        let coords = FormationUtils.convertShipCoordsToPolarPoints(warships: warships)
        let currentFormation = GameScene.formationCalculator.calculateCurrentFormation(for: coords)
        
        if currentFormation != .one && currentFormation != .two && currentFormation != .three && currentFormation != .four {
            let currentPts: [CGPoint] = FormationUtils.getCurrentShipsPosition(warships: warships)
            
            // generate positions for true and reciprocal brg
            let trueBrgPositions = FormationUtils.generatePositions(for: trueBrg, warships: warships, refShip: refShip)
            let reciprocalBrg = (trueBrg + CGFloat(180)).truncatingRemainder(dividingBy: CGFloat(360))
            let reciprocalPositions = FormationUtils.generatePositions(for: reciprocalBrg, warships: warships, refShip: refShip)
            
            // check to see which new set of positions requires travelling a shorter distance
            let d1 = FormationUtils.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: trueBrgPositions)
            let d2 = FormationUtils.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: reciprocalPositions)
            
            // if both distances are valid
            if d1 != -1 && d2 != -1 {
                if d1 < d2 {
                    FormationUtils.move(ships: warships, to: trueBrgPositions, refShip: refShip)
                }
                else if d1 > d2 {
                    FormationUtils.move(ships: warships, to: reciprocalPositions, refShip: refShip)
                }
                else {
                    print("DEBUG: failed to run. d1 \(d1) d2 \(d2)")
                    return
                }
            }
        }
        else {
            
        }
    }
}
