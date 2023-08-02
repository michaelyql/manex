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
        let coords = CommandUtils.convertShipCoordsToPolarPoints(warships: warships)
        let currentFormation = GameScene.formationCalculator.calculateCurrentFormation(for: coords)
        
        if currentFormation != .one && currentFormation != .two && currentFormation != .three && currentFormation != .four {
            let currentPts: [CGPoint] = CommandUtils.getCurrentShipsPosition(warships: warships)
            
            // generate positions for true and reciprocal brg
            let trueBrgPositions = CommandUtils.generatePositionsToCompare(for: trueBrg, warships: warships, refShip: refShip)
            let reciprocalBrg = (trueBrg + CGFloat(180)).truncatingRemainder(dividingBy: CGFloat(360))
            let reciprocalPositions = CommandUtils.generatePositionsToCompare(for: reciprocalBrg, warships: warships, refShip: refShip)
            
            // check to see which new set of positions requires travelling a shorter distance
            let d1 = CommandUtils.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: trueBrgPositions)
            let d2 = CommandUtils.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: reciprocalPositions)
            
            // if both distances are valid
            if d1 != -1 && d2 != -1 {
                if d1 < d2 {
                    CommandUtils.move(warships: warships, to: trueBrgPositions, refShip: refShip)
                }
                else if d1 > d2 {
                    CommandUtils.move(warships: warships, to: reciprocalPositions, refShip: refShip)
                }
                else {
                    print("DEBUG: failed to run. d1 \(d1) d2 \(d2)")
                    return
                }
            }
        }
        else {
            let shipsAhead = CommandUtils.findShipsAhead(warships: warships, refShip: refShip)
            let shipsAstern = CommandUtils.findShipsAstern(warships: warships, refShip: refShip)
            let shipsPortBeam = CommandUtils.findShipsPortBeam(warships: warships, refShip: refShip)
            let shipsStbdBeam = CommandUtils.findShipsStbdBeam(warships: warships, refShip: refShip)
            
            // if there are both ships ahead and astern
            if !shipsAhead.isEmpty && !shipsAstern.isEmpty {
                let shipsToMove = shipsAhead + shipsAstern
                // ships ahead will form on bearing indicated. ships astern will form on reciprocal bearing
                let newPos = CommandUtils.generatePositionsForTrueAndReciprocal(warships: shipsToMove, trueBrg: trueBrg, refShip: refShip)
                CommandUtils.move(warships: shipsToMove, to: newPos, refShip: refShip)
            }
            
            // if there are only ships ahead
            else if !shipsAhead.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getAsternBearing() {
                    CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getAsternBearing() {
                    CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[Warship.numberOfShips-1])
                }
                else {
                    if CommandUtils.isAngleBetweenRange(angleToCheck: trueBrg, referenceAngle: refShip.getTrueHeading()) {
                        CommandUtils.haulOut(to: trueBrg, warships: shipsAhead, refShip: refShip)
                    }
                    else {
                        let newPos = CommandUtils.generatePositionsForTrueOnly(warships: shipsAhead, trueBrg: trueBrg, refShip: refShip)
                        CommandUtils.move(warships: shipsAhead, to: newPos, refShip: refShip)
                    }
                }
            }
            
            // if there are only ships astern
            else if !shipsAstern.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getTrueHeading() {
                    CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getTrueHeading() {
                    CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[Warship.numberOfShips-1])
                }
                else {
                    if CommandUtils.isAngleBetweenRange(angleToCheck: trueBrg, referenceAngle: refShip.getAsternBearing()) {
                        CommandUtils.haulOut(to: trueBrg, warships: warships, refShip: refShip)
                    }
                    else {
                        let newPos = CommandUtils.generatePositionsForTrueOnly(warships: shipsAstern, trueBrg: trueBrg, refShip: refShip)
                        CommandUtils.move(warships: shipsAstern, to: newPos, refShip: refShip)
                    }
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
