//
//  CommandHandler.swift
//  manex
//
//  Created by michaelyangqianlong on 2/6/23.
//

// TODO: - implement FormTrueBrgWithDivHandler class and FormGolfTrueBrgHandler class

import SpriteKit

protocol FormationCommandHandler {
    func execute()
}

class FormationCommandFactory {
    
    static let PORT_DIR = 0
    static let STBD_DIR = 1
    static let DIV_LEVEL = 0
    static let SUBDIV_LEVEL = 1
    static let UNSELECTED = -1
    
    static func getCommandHandler(for inputs: FormationInputs, refShip: Warship, warshipsArray: [Warship]) throws -> FormationCommandHandler {
        
        if !inputs.isGolfSwitchOn {
            if inputs.divSeparation == UNSELECTED {
                if let trueBrg = inputs.trueBrg {
                    return FormationTrueBearingCommandHandler(trueBrg: trueBrg, refShip: refShip, warshipsArray: warshipsArray)
                }
                else if let relBrg = inputs.relBrg {
                    // just reuse the formation true bearing functionality
                    let trueBrg = try convertRelToTrueBrg(relDir: inputs.relDir, relBrg: relBrg, refShip: refShip)
                    return FormationTrueBearingCommandHandler(trueBrg: trueBrg, refShip: refShip, warshipsArray: warshipsArray)
                }
                else {
                    throw FormationInputError.noBearingIndicated
                }
            }
            else {
                if let trueBrg = inputs.trueBrg {
                    return FormationTrueBearingWithDivHandler(trueBrg: trueBrg, refShip: refShip)
                }
                else {
                    throw FormationInputError.noTrueBearingIndicated
                }
            }
        }
        else {
            if inputs.divSeparation != UNSELECTED {
                if let trueBrg = inputs.trueBrg {
                    return FormationGolfTrueBearingHandler()
                }
                else if let relBrg = inputs.relBrg {
                    // just convert rel to true brg and reuse the true brg golf div handler
                    let trueBrg = try convertRelToTrueBrg(relDir: inputs.relDir, relBrg: relBrg, refShip: refShip)
                    return FormationGolfTrueBearingHandler()
                }
                else {
                    throw FormationInputError.noBearingIndicated
                }
            }
            else {
                // based on signal definition, 'FORM G' must indicate either 'div' or 'subdiv'
                // hence if no div separation is indicated, the input is wrong
                throw FormationInputError.noDivSeparationIndicated
            }
        }
    }
    
    static func convertRelToTrueBrg(relDir: Int, relBrg: CGFloat, refShip: Warship) throws -> CGFloat {
        var trueBrg: CGFloat
        if relDir == PORT_DIR {
            trueBrg = refShip.getTrueHeading() - relBrg // relBrg ranges from 0-180
            if trueBrg < 0 {
                trueBrg = trueBrg + CGFloat(360)
            }
            return trueBrg
        }
        else if relDir == STBD_DIR {
            trueBrg = (refShip.getTrueHeading() + relBrg).truncatingRemainder(dividingBy: CGFloat(360))
            return trueBrg
        }
        else {
            throw FormationInputError.noRelativeDirectionIndicated
        }
    }
}

enum FormationInputError: Error {
    case noBearingIndicated
    case noTrueBearingIndicated
    case noDivSeparationIndicated
    case noRelativeDirectionIndicated
}
