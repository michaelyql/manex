//
//  CommandHandlers.swift
//  manexapp
//
//  Created by michaelyangqianlong on 15/5/23.
//

import SpriteKit

// These are the functions that get called when user presses the 'Execute' button
// Logic is implemented by each individual Handler type; just call handler.execute()
extension GameScene {
    
    func executeFormation(with formationInputs: FormationInputs, withReferenceTo refShip: Warship) {
        do {
            let handler = try FormationCommandFactory.getCommandHandler(for: formationInputs, refShip: refShip, warships: warshipsArray)
            handler.execute(parentScene: self)
        }
        catch {
            gameVC?.handleUserInputError(error)
        }
    }
    
    func executeCorpen(with corpenInputs: CorpenInputs) {
        print("executing corpen")
    }
    
    func executeTurn(with turnInputs: TurnInputs) {
        do {
            if let trueBrg = turnInputs.trueBrg {
                turnShips(to: trueBrg)
            }
            else if let relBrg = turnInputs.relBrg {
                if turnInputs.relDir != -1 {
                    // convert rel brg to true brg then just call the same function
                    // 0 for port, 1 for stbd
                    var trueBrg = CGFloat.zero
                    let offset = -warshipsArray[0].zRotation / .pi * 180
                    if turnInputs.relDir == 0 {
                        trueBrg = offset - relBrg
                    }
                    else if turnInputs.relDir == 1 {
                        trueBrg = (relBrg + offset).truncatingRemainder(dividingBy: 360)
                    }
                    turnShips(to: trueBrg)
                }
                else {
                    throw TurnInputError.noRelativeDirectionIndicated
                }
            }
            // update formation here
        }
        catch {
            gameVC?.handleUserInputError(error)
        }
    }

    func corpenTrueBearing(trueBrg: CGFloat) {}
    
    func corpenRelBrg(relativeDir: Int, relBrg: CGFloat) {}
    
    func corpenDelta(trueBrg: CGFloat) {}
}

enum TurnInputError: Error {
    case noRelativeDirectionIndicated
}
