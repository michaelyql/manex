//
//  [Warship]+Extension.swift
//  manex
//
//  Created by Michael Yang Qianlong on 2/8/23.
//

import Foundation

extension Array where Element == Warship {
    
    // Formation is normalized and assumed to be facing 000
    func toPolarPoints() -> [PolarPoint] {
        var p: [PolarPoint] = []
        guard self.count > 0 else { return p }
        
        // first ship is the origin that every other ship is referenced from
        let originX = self[0].position.x
        let originY = self[0].position.y
        
        for i in 0..<self.count {
            if i == 0 {
                p.append(PolarPoint(r: 0, a: 0))
                continue
            }
            let ship = self[i]
            // calculate ship's distance from origin
            let distance = hypot((ship.position.x - originX), (ship.position.y - originY))
            
            // calcuate ship's angle of rotation from origin (w.r.t Y-axis)
            let trueAngle: CGFloat = -atan2((ship.position.y - originY), ship.position.x - originX) + .pi / 2
            
            let relativeAngle = trueAngle + ship.zRotation < 0
            ? (trueAngle + ship.zRotation + .pi * 2)
            : (trueAngle + ship.zRotation)
            
            p.append(PolarPoint(r: distance, a: relativeAngle))
        }
        return p
        
        /* CALCULATIONS
         atan2 is used to get angle in all 4 quadrants.
         since atan2 measures angles w.r.t X axis, .pi/2 needs to be added so that angles are w.r.t Y axis
         we need positive angle to represent clockwise rotation but for atan2 positive angle means
         counterclockwise rotation. hence we need to negate atan2
         
         finally, relativeAngle = trueAngle - (-ship.zRotation)
         thus relativeAngle = trueAngle + ship.zRotation
         */
    }
    
    func getCurrPositions() -> [CGPoint] {
        var pts: [CGPoint] = []
        for ship in self {
            pts.append(ship.position)
        }
        return pts
    }
}
