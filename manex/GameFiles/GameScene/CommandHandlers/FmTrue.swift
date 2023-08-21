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
        print("Beginning to move ships.")
            
        if currentFormation != .one && currentFormation != .two && currentFormation != .three && currentFormation != .four {
            print("INFO: Current formation is not 1 to 4")
            
            self.compareDistancesAndMove(trueBrg: trueBrg)
        }
        else {
            print("INFO: Formation is either 1,2,3 or 4")
            let shipsAhead = CommandUtils.findShipsAhead(warships: warships, refShip: refShip)
            let shipsAstern = CommandUtils.findShipsAstern(warships: warships, refShip: refShip)
            let shipsPortBeam = CommandUtils.findShipsPortBeam(warships: warships, refShip: refShip)
            let shipsStbdBeam = CommandUtils.findShipsStbdBeam(warships: warships, refShip: refShip)
            
            // if there are both ships ahead and astern
            if !shipsAhead.isEmpty && !shipsAstern.isEmpty {
                self.compareDistancesAndMove(trueBrg: trueBrg, currentFormation: currentFormation)
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
            
            // there are ships both port and stbd, i.e. ref ship is not at either end
            else if !shipsPortBeam.isEmpty && !shipsStbdBeam.isEmpty {
                self.compareDistancesAndMove(trueBrg: trueBrg, currentFormation: currentFormation)
            }
            
            
            else if !shipsPortBeam.isEmpty {
                // Check if the target true bearing results in a reversal in formation
                // I.e. Form 3 -> Form 4 and vice versa
                // If there are only ships to port beam and the target heading is 90 deg
                // to stbd w.r.t ref ship heading
                if trueBrg == (refShip.getTrueHeading(plus: 90)) {
                    if currentFormation == .four {
                        CommandUtils.haulOutAstern(to: trueBrg, warships: warships.reversed(), refShip: refShip)
                    }
                    else if currentFormation == .three {
                        CommandUtils.haulOutAstern(to: trueBrg, warships: warships, refShip: refShip)
                    }
                }
                else {
                    self.compareDistancesAndMove(trueBrg: trueBrg)
                }
            }
            
            else if !shipsStbdBeam.isEmpty {
                if trueBrg == (refShip.getTrueHeading(plus: 270)) {
                    if currentFormation == .four {
                        CommandUtils.haulOutAstern(to: trueBrg, warships: warships, refShip: refShip)
                    }
                    else if currentFormation == .three {
                        CommandUtils.haulOutAstern(to: trueBrg, warships: warships.reversed(), refShip: refShip)
                    }
                }
                else {
                    self.compareDistancesAndMove(trueBrg: trueBrg)
                }
            }
            else {
                print("Error - no ships found")
            }
        }
        return
    }
    
    private func compareDistancesAndMove(trueBrg: CGFloat, currentFormation: FormationType? = nil) {
        
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
                CommandUtils.move(warships: warships, to: trueBrgPositions, refShip: refShip)
            }
            else if d1 > d2 {
                CommandUtils.move(warships: warships, to: reciprocalPositions, refShip: refShip)
            }
            else {
                // In this case, it probably means that the formation is converting
                // from Column to Line Abreast, and the ref ship is not at either end.
                // Thus ships ahead (for column formation) and ships to port (line abreast)
                // will form on the bearing indicated. The rest will form on the reciprocal
                
                if let fmn = currentFormation {
                    switch fmn {
                    case .one, .three:
                        CommandUtils.move(warships: warships, to: trueBrgPositions, refShip: refShip)
                    case .two, .four:
                        CommandUtils.move(warships: warships, to: reciprocalPositions, refShip: refShip)
                    default:
                        break
                    }
                }
            }
        }
    }
}
