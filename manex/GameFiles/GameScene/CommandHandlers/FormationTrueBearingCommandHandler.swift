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
    
    // This is an absolute abomination of a function
    func execute() {
        let coords = CommandHelpers.convertShipCoordsToPolarPoints(warships: warships)
        let currentFormation = GameScene.formationCalculator.calculateCurrentFormation(for: coords)
        
        if currentFormation != .one && currentFormation != .two && currentFormation != .three && currentFormation != .four {
            let currentPts: [CGPoint] = CommandHelpers.getCurrentShipsPosition(warships: warships)
            
            // generate positions for true and reciprocal brg
            let trueBrgPositions = CommandHelpers.generatePositionsToCompare(for: trueBrg, warships: warships, refShip: refShip)
            let reciprocalBrg = (trueBrg + CGFloat(180)).truncatingRemainder(dividingBy: CGFloat(360))
            let reciprocalPositions = CommandHelpers.generatePositionsToCompare(for: reciprocalBrg, warships: warships, refShip: refShip)
            
            // check to see which new set of positions requires travelling a shorter distance
            let d1 = CommandHelpers.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: trueBrgPositions)
            let d2 = CommandHelpers.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: reciprocalPositions)
            
            // if both distances are valid
            if d1 != -1 && d2 != -1 {
                if d1 < d2 {
                    CommandHelpers.move(warships: warships, to: trueBrgPositions, refShip: refShip)
                }
                else if d1 > d2 {
                    CommandHelpers.move(warships: warships, to: reciprocalPositions, refShip: refShip)
                }
                else {
                    print("DEBUG: failed to run. d1 \(d1) d2 \(d2)")
                    return
                }
            }
        }
        else {
            let shipsAhead = CommandHelpers.findShipsAhead(warships: warships, refShip: refShip)
            let shipsAstern = CommandHelpers.findShipsAstern(warships: warships, refShip: refShip)
            let shipsPortBeam = CommandHelpers.findShipsPortBeam(warships: warships, refShip: refShip)
            let shipsStbdBeam = CommandHelpers.findShipsStbdBeam(warships: warships, refShip: refShip)
            
            if !shipsAhead.isEmpty && !shipsAstern.isEmpty {
                let shipsToMove = shipsAhead + shipsAstern
                // ships ahead to form on bearing indicated. ships astern to form on reciprocal bearing
                let newPos = CommandHelpers.generatePositionsForTrueAndReciprocal(warships: shipsToMove, trueBrg: trueBrg, refShip: refShip)
                CommandHelpers.move(warships: shipsToMove, to: newPos, refShip: refShip)
                
                // only if there are ships both ahead and astern, then ships ahead will form on
                // bearing indicated while ships astern form on reciprocal bearing
            }
            
            
            else if !shipsAhead.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getAsternBearing() {
                    CommandHelpers.haulOutToPort(warships: warships, shipToHaulOutLast: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getAsternBearing() {
                    CommandHelpers.haulOutToPort(warships: warships, shipToHaulOutLast: warships[Warship.numberOfShips-1])
                }
                else {
                    if CommandHelpers.isAngleBetweenRange(angleToCheck: trueBrg, referenceAngle: refShip.getAsternBearing()) {
                        CommandHelpers.haulOut(to: trueBrg, warships: shipsAhead, refShip: refShip)
                    }
                    else {
                        let newPos = CommandHelpers.generatePositionsForTrueOnly(warships: shipsAhead, trueBrg: trueBrg, refShip: refShip)
                        CommandHelpers.move(warships: shipsAhead, to: newPos, refShip: refShip)
                    }
                }
            }
            
            
            else if !shipsAstern.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getTrueHeading() {
                    CommandHelpers.haulOutToPort(warships: warships, shipToHaulOutLast: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getTrueHeading() {
                    CommandHelpers.haulOutToPort(warships: warships, shipToHaulOutLast: warships[Warship.numberOfShips-1])
                }
                else {
                    
                    // check difference in angle
                    
                    let newPos = CommandHelpers.generatePositionsForTrueOnly(warships: shipsAstern, trueBrg: trueBrg, refShip: refShip)
                    CommandHelpers.move(warships: shipsAstern, to: newPos, refShip: refShip)
                }
            }
            
            
            else if !shipsPortBeam.isEmpty && !shipsStbdBeam.isEmpty {
                // implement haulOutAstern() - very similar to search turn
            }
            
            
            else if !shipsPortBeam.isEmpty {
                
            }
            
            
            else if !shipsStbdBeam.isEmpty {
                
            }
            else {
                print("Error - no ships found")
                return
            }
        }
    }
}
