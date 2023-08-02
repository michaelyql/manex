//
//  CommandHandlerUtilities.swift
//  manexapp
//
//  Created by michaelyangqianlong on 15/5/23.
//

import SpriteKit

extension GameScene {
    
    func calculateTotalDistanceTravelled(between p1: [CGPoint], and p2: [CGPoint]) -> CGFloat {
        if p1.count != p2.count {
            return -1
        }
        
        var total = CGFloat.zero
        for i in 0..<p1.count {
            let currP1 = p1[i]
            let currP2 = p2[i]
            let d = (pow((currP1.x - currP2.x), 2) + pow((currP1.y - currP2.y), 2)).squareRoot()
            total += d
        }
        return total
    }
    
    func generatePositions(forTrueBearing trueBrg: CGFloat, refShipIndex idx: Int) -> [CGPoint] {
        var newPts: [CGPoint] = []
        let refShip = warshipsArray[idx]
        
        let brgInRadians = trueBrg / 180 * .pi

        for i in 0...idx { // including ref ship as well
            let newX = refShip.position.x - 150 * sin(brgInRadians) * CGFloat(idx-i)
            let newY = refShip.position.y - 150 * cos(brgInRadians) * CGFloat(idx-i)
            newPts.append(CGPoint(x: newX, y: newY))
        }
        
        for i in idx+1..<warshipsArray.count {
            let newX = refShip.position.x + 150 * sin(brgInRadians) * CGFloat(i-idx)
            let newY = refShip.position.y + 150 * cos(brgInRadians) * CGFloat(i-idx)
            newPts.append(CGPoint(x: newX, y: newY))
        }
        return newPts
    }
    
    func generatePositions(for ships: [Warship], trueBearing: CGFloat, refShip: Warship) -> [CGPoint] {
        var p: [CGPoint] = []
        let angleInRad = trueBearing / 180 * .pi
        
        // only the intersecting ships are included here 
        for ship in ships {
            if ship.sequenceNum < refShip.sequenceNum {
                let newX = refShip.position.x + 150 * sin(angleInRad) * CGFloat(refShip.sequenceNum-ship.sequenceNum)
                let newY = refShip.position.y + 150 * cos(angleInRad) * CGFloat(refShip.sequenceNum-ship.sequenceNum)
                p.append(CGPoint(x: newX, y: newY))
            }
            else {
                let newX = refShip.position.x - 150 * sin(angleInRad) * CGFloat(ship.sequenceNum-refShip.sequenceNum)
                let newY = refShip.position.y - 150 * cos(angleInRad) * CGFloat(ship.sequenceNum-refShip.sequenceNum)
                p.append(CGPoint(x: newX, y: newY))
            }
        }
        
        return p
    }
    
    func getCurrentShipsPosition(excludingIndex excludedIdx: Int) -> [CGPoint] {
        var pts: [CGPoint] = []
        for i in 0..<warshipsArray.count {
            if i == excludedIdx {
                continue
            }
            pts.append(warshipsArray[i].position)
        }
        return pts
    }
    
    func getCurrentShipsPosition() -> [CGPoint] {
        var pts: [CGPoint] = []
        for i in 0..<warshipsArray.count {
            pts.append(warshipsArray[i].position)
        }
        return pts
    }

    func turnShips(to direction: CGFloat) {
        let angleInRad = -direction / 180 * .pi
        let rotateAction = SKAction.rotate(toAngle: angleInRad, duration: TURN_DURATION, shortestUnitArc: true)
        for ship in warshipsArray {
            ship.run(rotateAction)
        }
    }
}
