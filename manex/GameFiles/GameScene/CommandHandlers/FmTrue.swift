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
    func execute(parentScene: GameScene) {
        print("-----------------------------")
        print("Executing Formation True Bearing")
        let points = warships.toPolarPoints()
        let currentFormation = FormationCalculator.calculateCurrentFormation(for: points)
        print("Current formation: \(currentFormation)")
        var resultantFormation: FormationType? = nil
        print("Beginning to move ships.")
            
        if currentFormation != .one && currentFormation != .two && currentFormation != .three && currentFormation != .four {
            print("INFO: Current formation is not 1 to 4")
            let currentPts: [CGPoint] = warships.getCurrPositions()
            
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
                    resultantFormation = CommandUtils.move(warships: warships, to: trueBrgPositions, refShip: refShip)
                }
                else if d1 > d2 {
                    resultantFormation = CommandUtils.move(warships: warships, to: reciprocalPositions, refShip: refShip)
                }
                else {
                    print("\(#function) failed to run. d1 and d2 are equal")
                }
            }
        }
        else {
            print("INFO: Formation is either 1,2,3 or 4")
            let shipsAhead = CommandUtils.findShipsAhead(warships: warships, refShip: refShip)
            let shipsAstern = CommandUtils.findShipsAstern(warships: warships, refShip: refShip)
            let shipsPortBeam = CommandUtils.findShipsPortBeam(warships: warships, refShip: refShip)
            let shipsStbdBeam = CommandUtils.findShipsStbdBeam(warships: warships, refShip: refShip)
            
            // if there are both ships ahead and astern
            if !shipsAhead.isEmpty && !shipsAstern.isEmpty {
                let shipsToMove = shipsAhead + shipsAstern
                // ships ahead will form on bearing indicated. ships astern will form on reciprocal bearing
                let newPos = CommandUtils.generatePositionsForTrueAndReciprocal(warships: shipsToMove, trueBrg: trueBrg, refShip: refShip)
                resultantFormation = CommandUtils.move(warships: shipsToMove, to: newPos, refShip: refShip)
            }
            
            // if there are only ships ahead
            else if !shipsAhead.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getAsternBearing() {
                    resultantFormation = CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getAsternBearing() {
                    resultantFormation = CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[Warship.numberOfShips-1])
                }
                else {
                    if CommandUtils.isAngleBetweenRange(angleToCheck: trueBrg, referenceAngle: refShip.getTrueHeading()) {
                        resultantFormation = CommandUtils.haulOut(to: trueBrg, warships: shipsAhead, refShip: refShip)
                    }
                    else {
                        let newPos = CommandUtils.generatePositionsForTrueOnly(warships: shipsAhead, trueBrg: trueBrg, refShip: refShip)
                        resultantFormation = CommandUtils.move(warships: shipsAhead, to: newPos, refShip: refShip)
                    }
                }
            }
            
            // if there are only ships astern
            else if !shipsAstern.isEmpty {
                if currentFormation == .one && trueBrg == refShip.getTrueHeading() {
                    resultantFormation = CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[0])
                }
                else if currentFormation == .two && trueBrg == refShip.getTrueHeading() {
                    resultantFormation = CommandUtils.haulOutToPort(warships: warships, shipToHaulOutLast: warships[Warship.numberOfShips-1])
                }
                else {
                    if CommandUtils.isAngleBetweenRange(angleToCheck: trueBrg, referenceAngle: refShip.getAsternBearing()) {
                        resultantFormation = CommandUtils.haulOut(to: trueBrg, warships: warships, refShip: refShip)
                    }
                    else {
                        let newPos = CommandUtils.generatePositionsForTrueOnly(warships: shipsAstern, trueBrg: trueBrg, refShip: refShip)
                        resultantFormation = CommandUtils.move(warships: shipsAstern, to: newPos, refShip: refShip)
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
            }
        }
        parentScene.currentFormation = resultantFormation
        return
    }
}
