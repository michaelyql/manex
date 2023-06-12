//
//  CorpenCommandFactory.swift
//  manex
//
//  Created by michaelyangqianlong on 12/6/23.
//

import SpriteKit

protocol CorpenCommandHandler {
    func execute() 
}

// TODO: figure out how to implement line guide and change of line guides
class CorpenCommandFactory {
    
    static func getCommandHandler(for inputs: CorpenInputs, currentFormation: FormationType) throws -> CorpenCommandHandler {
        
        // check if ships are on line of bearing. if yes, return
        
        // check if line guides are abeam or astern of each other. if no, return (except for corpen D)
        
        // check that wheel does not exceed 180º for columns
        // check that wheel does not exceed 90º for lines abreast
        // check that wheel does not exceed 30º for diamond formation
        
        if let trueBrg = inputs.trueBrg {
            if inputs.isDeltaSwitchOn == false {
                return CorpenTrueBrgCommandHandler(trueBrg: trueBrg)
            }
            else {
                return CorpenDeltaBrgCommandHandler(trueBrg: trueBrg)
            }
        }
        else {
            throw CommandInputError.noTrueBearingIndicated
        }
    }
}

enum CommandInputError: Error {
    case noTrueBearingIndicated
}
