//
//  FormationUtils.swift
//  manex
//
//  Created by michaelyangqianlong on 3/6/23.
//

import SpriteKit
import UIKit

// TODO: - Port all of the signal execution utility functions over to this class 

class FormationUtils {
    
    static func getCurrentShipsPosition(warships: [Warship]) -> [CGPoint] {
        var pts: [CGPoint] = []
        for ship in warships {
            pts.append(ship.position)
        }
        return pts
    }
    
    static func convertShipCoordsToPolarPoints(warships: [Warship]) -> [PolarPoint] {
        var p: [PolarPoint] = []
        guard warships.count > 0 else { return p }
        
        // first ship is the origin that every other ship is referenced from
        let originX = warships[0].position.x
        let originY = warships[0].position.y
        
        for ship in warships {
            if ship == warships[0] {
                p.append(PolarPoint(r: 0, a: 0))
                continue
            }
            
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
        
        /* CALCULATIONS EXPLAINED
         atan2 is used to get angle in all 4 quadrants.
         since atan2 measures angles w.r.t X axis, .pi/2 needs to be added so that angles are w.r.t Y axis
         we need positive angle to represent clockwise rotation but for atan2 positive angle means
         counterclockwise rotation. hence we need to negate atan2
         
         finally, relativeAngle = trueAngle - (-ship.zRotation)
         thus relativeAngle = trueAngle + ship.zRotation
         */
    }
    
    static func generatePositions(for trueBrg: CGFloat, warships: [Warship], refShip: Warship) -> [CGPoint] {
        var newPts: [CGPoint] = []
        let angleInRadians = trueBrg / 180 * .pi
        
        for ship in warships {
            let newX: CGFloat
            let newY: CGFloat
            
            // new points on bearing indicated
            if ship.sequenceNum < refShip.sequenceNum {
                newX = refShip.position.x + 150 * sin(angleInRadians) * CGFloat(refShip.sequenceNum - ship.sequenceNum)
                newY = refShip.position.y + 150 * cos(angleInRadians) * CGFloat(refShip.sequenceNum - ship.sequenceNum)
            }
            
            // new points on reciprocal bearing
            else {
                newX = refShip.position.x - 150 * sin(angleInRadians) * CGFloat(refShip.sequenceNum - ship.sequenceNum)
                newY = refShip.position.y - 150 * cos(angleInRadians) * CGFloat(refShip.sequenceNum - ship.sequenceNum)
            }
            newPts.append(CGPoint(x: newX, y: newY))
        }
        return newPts
    }
    
    static func calculateTotalDistanceTravelledBetween(origin: [CGPoint], destination: [CGPoint]) -> CGFloat {
        guard origin.count == destination.count else { return -1 }
        
        var totalDist = CGFloat.zero
        for i in 0..<origin.count {
            let originPt = origin[i]
            let destPt = destination[i]
            // distTravelled = sqrt(deltaX^2 + deltaY^2)
            let distTravelled = (pow((originPt.x - destPt.x), 2) + pow((originPt.y - destPt.y), 2)).squareRoot()
            totalDist += distTravelled
        }
        return totalDist
    }
    
    static func move(ships: [Warship], to newPos: [CGPoint], refShip: Warship) {
        guard newPos.count == ships.count else { return }
        
        let prevHeading = refShip.zRotation
        for i in 0..<newPos.count {
            if ships[i] == refShip {
                continue
            }
            let currShip = ships[i]
            let path = UIBezierPath()
            path.move(to: currShip.position)
            path.addLine(to: newPos[i])
            
            let moveAction = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 100)
            currShip.run(moveAction, completion: {
                currShip.zRotation = prevHeading
            })
        }
    }
    
    static func findShips(relBrg: CGFloat, warships: [Warship], refShip: Warship) -> [Warship] {
        let refLine = SKSpriteNode(texture: SKTexture(imageNamed: "referenceLine"))
        refShip.addChild(refLine)
        refLine.anchorPoint = CGPoint(x: 0.5, y: 0)
        refLine.zRotation -= relBrg / 180 * .pi
        
        var intersections: [Warship] = []
        for ship in warships {
            if ship == refShip {
                continue
            }
            if refLine.intersects(ship) {
                intersections.append(ship)
            }
        }
        refLine.removeFromParent()
        return intersections
    }
    
    static func findShipsAhead(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: 0, warships: warships, refShip: refShip)
    }
    
    static func findShipsAstern(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: 180, warships: warships, refShip: refShip)
    }
    
    static func findShipsPortBeam(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: -90, warships: warships, refShip: refShip)
    }
    
    static func findShipsStbdBeam(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: 90, warships: warships, refShip: refShip)
    }
    
}
