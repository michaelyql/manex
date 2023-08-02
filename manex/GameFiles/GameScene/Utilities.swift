//
//  GameSceneUtilities.swift
//  manexapp
//
//  Created by michaelyangqianlong on 12/5/23.
//

import SpriteKit

extension GameScene {
    
    // MARK: - game logic utils
    // relBrg is in degrees
    func convertToTrueBearing(from relBrg: CGFloat, direction: Int, refShip: Warship) -> CGFloat {
        let PORT_DIR = 0
        let STBD_DIR = 1
        
        var trueBrg = CGFloat.zero
        let offset = -refShip.zRotation
        if direction == PORT_DIR {
            trueBrg = offset - relBrg / 180 * .pi
        }
        else if direction == STBD_DIR {
            trueBrg = offset + relBrg / 180 * .pi
        }
        // trueBrg is given in radians
        // positive value represents clockwise rotation
        // i.e. if trueBrg is pi/2, the rotation is pi/2 clockwise
        return trueBrg
    }
    
    // convert from true bearing to rel bearing
    func convertToRelativeBearing(from trueBrg: CGFloat) -> CGFloat {
        let offset = -warshipsArray[0].zRotation / .pi * 180
        let relBrg = trueBrg - offset
        return relBrg
    }
    
    // Each polar point gives angle relative to reference ship's heading
    // In other words, the formation will be normalized to face 000
    func convertShipCoordsToPolarPoints() -> [PolarPoint] {
        var p: [PolarPoint] = []
        
        // the point of reference (origin) will be the first ship in formation
        let originX = warshipsArray[0].position.x
        let originY = warshipsArray[0].position.y
        
        // calculate distance and angle of current ship from first ship, including itself
        for ship in warshipsArray {
            // distance of warship from first ship
            let distance = hypot((ship.position.x - originX), (ship.position.y - originY))
            
            /*
             this calculates the angle of current warship from first ship
             atan2 calculate angles including top and bottom left quadrants where x<0
             atan only calculates angles for top and bottom right quadrants (x>0)
                 
             atan2 is inversed because counterclockwise rotation is considered positive
             rotation, whereas we need the opposite (for clockwise rotation to be positive)
                 
             addiitonally, (.pi / 2) is added to the result because atan2 calculates angles
             from the positive X axis, but we need angles starting from the positive Y axis
            */
            var trueAngle: CGFloat
            trueAngle = -atan2((ship.position.y - originY), (ship.position.x - originX)) + .pi / 2
            if ship == warshipsArray[0] {
                trueAngle = 0
            }
            // relativeAngle = trueAngle - (-warship.zRotation)
            var relativeAngle = (trueAngle + ship.zRotation) < 0
            ? (trueAngle + ship.zRotation + .pi * 2)
            : (trueAngle + ship.zRotation)
            
            if ship == warshipsArray[0] {
                relativeAngle = 0
            }
            
            p.append(PolarPoint(r: distance, a: relativeAngle))
        }
        return p
    }
}
