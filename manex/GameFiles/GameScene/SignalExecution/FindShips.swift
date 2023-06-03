//
//  FindShips.swift
//  manex
//
//  Created by michaelyangqianlong on 1/6/23.
//

import SpriteKit

extension GameScene {
    
    func findShips(trueBearing bearing: CGFloat, refShip: Warship) -> [Warship] {

        // refLine is a rectangle roughly 1 x 1000 units long
        let refLine = SKSpriteNode(texture: SKTexture(imageNamed: "referenceLine"))
        addChild(refLine)
        refLine.anchorPoint = CGPoint(x: 0.5, y: 0)
        refLine.position = refShip.position
        refLine.zRotation = -bearing / 180 * .pi
        
        var intersections: [Warship] = []
        for ship in warshipsArray {
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
    
    func findShipsAhead(refShip: Warship) -> [Warship] {
        let shipsHeading: CGFloat = -refShip.zRotation / .pi * 180
        let intersections = findShips(trueBearing: shipsHeading, refShip: refShip)
        return intersections

    }
    
    func findShipsAstern(refShip: Warship) -> [Warship] {
        let astern = (-refShip.zRotation / .pi * 180 + CGFloat(180)).truncatingRemainder(dividingBy: CGFloat(360))
        let intersections = findShips(trueBearing: astern, refShip: refShip)
        return intersections
    }
    
    func findShipsPortBeam(refShip: Warship) -> [Warship] {
        let tmp = -refShip.zRotation / .pi * 180 - 90
        let portBeam: CGFloat
        if tmp >= 0 {
            portBeam = tmp
        }
        else {
            portBeam = 360 - abs(tmp)
        }
        let intersections = findShips(trueBearing: portBeam, refShip: refShip)
        return intersections
    }
    
    func findShipsStbdBeam(refShip: Warship) -> [Warship] {
        let stbdBeam = (-refShip.zRotation / .pi * 180 + CGFloat(90)).truncatingRemainder(dividingBy: CGFloat(360))
        let intersections = findShips(trueBearing: stbdBeam, refShip: refShip)
        return intersections
    }
    
    func findShipsPortBow() {
        
    }
    
    func findShipsPortQtr() {
        
    }
    
    func findShipsStbdBow() {
        
    }
    
    func findShipStbdQtr() {
        
    }
    
    func getShipsBearing(relativeTo refShip: Warship) {
        
        // get each ship's polar angle from ref ship
        
        // check 4 quadrants to see if the ship belongs inside that quadrant and add accordingly
        
        // return a tuple of 4 lists representing the 4 quadrants 
    }
    
}
