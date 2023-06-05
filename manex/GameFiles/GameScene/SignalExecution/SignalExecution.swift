//
//  CommandHandlers.swift
//  manexapp
//
//  Created by michaelyangqianlong on 15/5/23.
//

import SpriteKit

// TODO: - break down each individual function into smaller parts
extension GameScene {
    
    func executeFormation(with formationInputs: FormationInputs, withReferenceTo refShip: Warship) {
        do {
            let handler = try FormationCommandFactory.getCommandHandler(for: formationInputs, refShip: refShip, warships: warshipsArray)
            handler.execute()
        }
        catch {
            gameVC?.handleFormationInputError(error)
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
