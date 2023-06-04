//
//  CommandHandlers.swift
//  manexapp
//
//  Created by michaelyangqianlong on 15/5/23.
//

import SpriteKit

// TODO: - break down each individual function into smaller parts
extension GameScene {
    
    func executeFormations(with formationInputs: FormationInputs, withReferenceTo refShip: Warship) {
        do {
            let coords = convertShipCoordsToPolarPoints()
            let currentFormation = GameScene.formationCalculator.calculateCurrentFormation(for: coords)
            
            let handler = try FormationCommandFactory.getCommandHandler(for: formationInputs, refShip: refShip, warships: warshipsArray)
            handler.execute()
        }
        catch {
            gameVC?.handleFormationInputError(error)
        }
    }
    
    // returns boolean whether command was execute or not
    func executeFormation(isFormGOn: Bool, trueBrg: CGFloat?, relativeDir: Int, relBrg: CGFloat?, divSeparation: Int, refShipIndex: Int) {
        
        if !isFormGOn {
            if divSeparation == -1 {
                if let trueBrg = trueBrg {
                    formationTrueBearingTest(trueBrg: trueBrg, refShip: warshipsArray[refShipIndex])
                }
                else if let relBrg = relBrg {
//                    formationRelBearing(relativeDir: relativeDir, relBrg: relBrg, refShip: warshipsArray[refShipIndex])
                }
            }
            else {
                if let trueBrg = trueBrg {
//                    formationTrueBearingWithDivision(div: divSeparation, trueBrg: trueBrg, refShip: warshipsArray[refShipIndex])
                }
            }
        }
        else {
            if divSeparation != -1 {
                
                // there shouldn't be such a case. Form G requires either div or subdiv command
                // throw an error in this case 
                
            }
            else {
                
            }
        }
    }
    
    func executeCorpen(isCorpenDOn: Bool, trueBrg: CGFloat) {
        print("executing corpen")
    }
    
    func executeTurn(trueBrg: CGFloat?, relativeDir: Int, relBrg: CGFloat?) {
        if let trueBrg = trueBrg {
            turnShips(to: trueBrg)
            // true bearing of formation should not change 
            // only the current formation should be updated
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TURN_DURATION) { [weak self] in
                self?.updateFormationAndFormationBearing()
            }
        }
        else if let relBrg = relBrg {
            if relativeDir != -1 {
                // convert rel brg to true brg then just call the same function 
                // 0 for port, 1 for stbd
                var trueBrg = CGFloat.zero
                let offset = -warshipsArray[0].zRotation / .pi * 180
                if relativeDir == 0 {
                    trueBrg = offset - relBrg
                }
                else if relativeDir == 1 {
                    trueBrg = (relBrg + offset).truncatingRemainder(dividingBy: 360)
                }
                turnShips(to: trueBrg)
                DispatchQueue.main.asyncAfter(deadline: .now() + TURN_DURATION) { [weak self] in
                    self?.updateFormationAndFormationBearing()
                }
            }
            else {
                // throw some error here
                // maybe send a call to game view controller as the delegate
                // pass in the error code as the parameter
                // VC will generate the error message view according to the message
            }
        }
    }
    
    func formationTrueBearingTest(trueBrg: CGFloat, refShip: Warship) {
        let refShipIdx = refShip.sequenceNum-1
        
        let coords = convertShipCoordsToPolarPoints()
        let currentFormation = GameScene.formationCalculator.calculateCurrentFormation(for: coords)
        
        if currentFormation != .one && currentFormation != .two && currentFormation != .three && currentFormation != .four {
            let currentPts: [CGPoint] = getCurrentShipsPosition()
            
            // generatating new positions
            let newPts1 = generatePositions(forTrueBearing: trueBrg, refShipIndex: refShipIdx)
            let newPts2 = generatePositions(forTrueBearing: (trueBrg + 180).truncatingRemainder(dividingBy: CGFloat(360)), refShipIndex: refShipIdx)
            
            // comparing distances
            let d1 = calculateTotalDistanceTravelled(between: currentPts, and: newPts1)
            let d2 = calculateTotalDistanceTravelled(between: currentPts, and: newPts2)
            
            // if both are valid distances
            if d1 != -1 && d2 != -1 {
                if d1 < d2 {
                    self.moveShipsTo(newPosition: newPts1, excludingIndex: refShipIdx)
                }
                else if d1 > d2 {
                    self.moveShipsTo(newPosition: newPts2, excludingIndex: refShipIdx)
                }
                else {
                    return
                }
            }
            else {
                print("failed to run")
                print("d1 \(d1) d2 \(d2)")
            }
        }
        else {
            
            let shipsAhead = findShipsAhead(refShip: refShip)
            let shipsAstern = findShipsAstern(refShip: refShip)
            let shipsPortBeam = findShipsPortBeam(refShip: refShip)
            let shipsStbdBeam = findShipsStbdBeam(refShip: refShip)
            
            if !shipsAhead.isEmpty && !shipsAstern.isEmpty {
                let ships = shipsAhead + shipsAstern
                let newPos = generatePositions(for: ships, trueBearing: trueBrg, refShip: refShip)
                move(ships: ships, to: newPos)
            }
            else if !shipsAhead.isEmpty {
                let newPos = generatePositions(for: shipsAhead, trueBearing: trueBrg, refShip: refShip)
    
                if currentFormation == .two && (trueBrg == refShip.getAsternBearing()) {
                    // check if user has selected port or stb
                    // if unselected, throw an exception and prompt user to select port or stbd
                    // if selected, choose function to execute
                    // haulOutToPort()
                    // or else
                    // haulOutToStbd()
                    
                    
                }
                else {
                    move(ships: shipsAhead, to: newPos)
                }
            }
            else if !shipsAstern.isEmpty {
                let newPos = generatePositions(for: shipsAstern, trueBearing: trueBrg, refShip: refShip)
                
                if currentFormation == .one && (trueBrg == refShip.getAsternBearing()) {
                    // haulOutToPort() or haulOutToStbd()
                    
                    // ship at the very end will haul out first, all other ships to follow 
                }
                
                move(ships: shipsAstern, to: newPos)
                
            }
            else if !shipsPortBeam.isEmpty && !shipsStbdBeam.isEmpty {
                let ships = shipsPortBeam + shipsStbdBeam
                let newPos = generatePositions(for: ships, trueBearing: trueBrg, refShip: refShip)
                move(ships: ships, to: newPos)
            }
            else if !shipsPortBeam.isEmpty {
                let newPos = generatePositions(for: shipsPortBeam, trueBearing: trueBrg, refShip: refShip)
                move(ships: shipsPortBeam, to: newPos)
                
                // implement haulOutAstern()
            }
            else if !shipsStbdBeam.isEmpty {
                let newPos = generatePositions(for: shipsStbdBeam, trueBearing: trueBrg, refShip: refShip)
                move(ships: shipsStbdBeam, to: newPos)
                
                // implement haulOutAstern()
                // basically search turn but still turn back to original heading at the end
                // search turn (corpen sierra) will lead to 90º change in heading, either to port or stbd
            }
        }
    }
    
    func corpenTrueBearing(trueBrg: CGFloat) {}
    
    func corpenRelBrg(relativeDir: Int, relBrg: CGFloat) {}
    
    func corpenDelta(trueBrg: CGFloat) {}
    
    func updateFormationAndFormationBearing(newBrg: CGFloat? = nil) {
        if let newBrg = newBrg {
            self.formationBearing = newBrg
        }
        let newFormation = GameScene.formationCalculator.calculateCurrentFormation(for: convertShipCoordsToPolarPoints())
        self.currentFormation = newFormation
    }
}
