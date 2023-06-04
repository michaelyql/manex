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
            let trueBrgPositions = FormationUtils.generatePositionsToCompare(for: trueBrg, warships: warships, refShip: refShip)
            let reciprocalBrg = (trueBrg + CGFloat(180)).truncatingRemainder(dividingBy: CGFloat(360))
            let reciprocalPositions = FormationUtils.generatePositionsToCompare(for: reciprocalBrg, warships: warships, refShip: refShip)
            
            // check to see which new set of positions requires travelling a shorter distance
            let d1 = FormationUtils.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: trueBrgPositions)
            let d2 = FormationUtils.calculateTotalDistanceTravelledBetween(origin: currentPts, destination: reciprocalPositions)
            
            // if both distances are valid
            if d1 != -1 && d2 != -1 {
                if d1 < d2 {
                    FormationUtils.move(warships: warships, to: trueBrgPositions, refShip: refShip)
                }
                else if d1 > d2 {
                    FormationUtils.move(warships: warships, to: reciprocalPositions, refShip: refShip)
                }
                else {
                    print("DEBUG: failed to run. d1 \(d1) d2 \(d2)")
                    return
                }
            }
        }
        else {
            let shipsAhead = FormationUtils.findShipsAhead(warships: warships, refShip: refShip)
            let shipsAstern = FormationUtils.findShipsAstern(warships: warships, refShip: refShip)
            let shipsPortBeam = FormationUtils.findShipsPortBeam(warships: warships, refShip: refShip)
            let shipsStbdBeam = FormationUtils.findShipsStbdBeam(warships: warships, refShip: refShip)
            
            if !shipsAhead.isEmpty && !shipsAstern.isEmpty {
                let shipsToMove = shipsAhead + shipsAstern
                // ships ahead to form on bearing indicated. ships astern to form on reciprocal bearing
                let newPos = FormationUtils.generatePositions(warships: shipsToMove, trueBrg: trueBrg, refShip: refShip)
                FormationUtils.move(warships: shipsToMove, to: newPos, refShip: refShip)
            }
            else if !shipsAhead.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getAsternBearing() {
                    FormationUtils.haulOutToPort(warships: warships, refShip: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getAsternBearing() {
                    FormationUtils.haulOutToPort(warships: warships, refShip: warships[Warship.numberOfShips-1])
                }
                else {
                    // unintended behaviour
                    // ships in form 2, command given is Form 000, ref ship 1
                    // all ships after ship 1 formed on reciprocal bearing
                    // need to make a check first whether ships are already in position and don't need to move
                    let newPos = FormationUtils.generatePositions(warships: shipsAhead, trueBrg: trueBrg, refShip: refShip)
                    FormationUtils.move(warships: shipsAhead, to: newPos, refShip: refShip)
                }
            }
            else if !shipsAstern.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getTrueHeading() {
                    FormationUtils.haulOutToPort(warships: warships, refShip: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getTrueHeading() {
                    FormationUtils.haulOutToPort(warships: warships, refShip: warships[Warship.numberOfShips-1])
                }
                else {
                    let newPos = FormationUtils.generatePositions(warships: shipsAstern, trueBrg: trueBrg, refShip: refShip)
                    FormationUtils.move(warships: shipsAstern, to: newPos, refShip: refShip)
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
