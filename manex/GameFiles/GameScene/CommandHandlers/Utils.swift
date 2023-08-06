//
//  FormationUtils.swift
//  manex
//
//  Created by michaelyangqianlong on 3/6/23.
//

import SpriteKit
import UIKit
import Foundation

class CommandUtils {
    
    static func generatePositionsToCompare(for trueBrg: CGFloat, warships: [Warship], refShip: Warship) -> [CGPoint] {
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
                newX = refShip.position.x - 150 * sin(angleInRadians) * CGFloat(ship.sequenceNum - refShip.sequenceNum)
                newY = refShip.position.y - 150 * cos(angleInRadians) * CGFloat(ship.sequenceNum - refShip.sequenceNum)
            }
            newPts.append(CGPoint(x: newX, y: newY))
        }
        return newPts
    }
    
    static func generatePositionsForTrueAndReciprocal(warships: [Warship], trueBrg: CGFloat, refShip: Warship) -> [CGPoint] {
        var newPts: [CGPoint] = []
        let angleInRadians = trueBrg / 180 * .pi
        
        for ship in warships {
            let newX: CGFloat
            let newY: CGFloat
            if ship.sequenceNum < refShip.sequenceNum {
                newX = refShip.position.x + 150 * sin(angleInRadians) * CGFloat(refShip.sequenceNum-ship.sequenceNum)
                newY = refShip.position.y + 150 * cos(angleInRadians) * CGFloat(refShip.sequenceNum-ship.sequenceNum)
            }
            else {
                newX = refShip.position.x - 150 * sin(angleInRadians) * CGFloat(ship.sequenceNum-refShip.sequenceNum)
                newY = refShip.position.y - 150 * cos(angleInRadians) * CGFloat(ship.sequenceNum-refShip.sequenceNum)
            }
            newPts.append(CGPoint(x: newX, y: newY))
        }
        return newPts
    }
    
    static func generatePositionsForTrueOnly(warships: [Warship], trueBrg: CGFloat, refShip: Warship) -> [CGPoint] {
        var newPts: [CGPoint] = []
        let angleInRadians = trueBrg / 180 * .pi
        
        for ship in warships {
            let multiplier = abs(refShip.sequenceNum-ship.sequenceNum)
            let newX = refShip.position.x + 150 * sin(angleInRadians) * CGFloat(multiplier)
            let newY = refShip.position.y + 150 * cos(angleInRadians) * CGFloat(multiplier)
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
    
    static func move(warships: [Warship], to newPos: [CGPoint], refShip: Warship) -> FormationType {
        
        guard newPos.count == warships.count else { return .none }
        
        let prevHeading = refShip.zRotation
        var resultantFormation: FormationType = .none
        
        for i in 0..<newPos.count {
            let currShip = warships[i]
            let path = UIBezierPath()
            path.move(to: currShip.position)
            path.addLine(to: newPos[i])
            
            let moveAction = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 100)
            currShip.run(moveAction, completion: {
                currShip.zRotation = prevHeading
                if i == newPos.count-1 {
                    // recalculate and update the formation
                    resultantFormation = FormationCalculator.calculateCurrentFormation(for: warships.toPolarPoints())
                }
            })
        }
        return resultantFormation
    }
    
    static func findShips(relBrg: CGFloat, warships: [Warship], refShip: Warship, tag: String) -> [Warship] {
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
        if !intersections.isEmpty {
            print("Found ships \(tag): \(intersections)")
        }
        return intersections
    }
    
    static func findShipsAhead(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: 0, warships: warships, refShip: refShip, tag: "Ahead")
    }
    
    static func findShipsAstern(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: 180, warships: warships, refShip: refShip, tag: "Astern")
    }
    
    static func findShipsPortBeam(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: -90, warships: warships, refShip: refShip, tag: "Port Beam")
    }
    
    static func findShipsStbdBeam(warships: [Warship], refShip: Warship) -> [Warship] {
        return findShips(relBrg: 90, warships: warships, refShip: refShip, tag: "Stbd Beam")
    }
    
    static func haulOutToPort(warships: [Warship], shipToHaulOutLast: Warship) -> FormationType {
        print("Calling \(#function) function in \((#file.split(separator: "/").last!))")
        let offset = -shipToHaulOutLast.zRotation
        
        var resultantFormation: FormationType = .none
        
        if warships[0] == shipToHaulOutLast {
            var i = CGFloat.zero
            for ship in warships {
                let controlPointBrg = offset - .pi/2
                let controlPoint = CGPoint(x: ship.position.x + 150 * sin(controlPointBrg),
                                           y: ship.position.y + 150 * cos(controlPointBrg))
                let destX = controlPoint.x + (i * CGFloat(300) + CGFloat(150)) * sin(offset)
                let destY = controlPoint.y + (i * CGFloat(300) + CGFloat(150)) * cos(offset)
                let destinationPoint = CGPoint(x: destX, y: destY)
                i += 1
                let pathToDest = UIBezierPath()
                pathToDest.move(to: ship.position)
                pathToDest.addCurve(to: destinationPoint, controlPoint1: controlPoint, controlPoint2: controlPoint)
                let moveAction = SKAction.follow(pathToDest.cgPath, asOffset: false, orientToPath: true, speed: 120)
                let waitAction = SKAction.wait(forDuration: TimeInterval(CGFloat(Warship.numberOfShips)-i) * 2.4)
                ship.run(waitAction, completion: {
                    ship.run(moveAction, completion: {
                        if ship == shipToHaulOutLast {
                            // recalculate and update the formation
                            resultantFormation = FormationCalculator.calculateCurrentFormation(for: warships.toPolarPoints())
                        }
                    })
                })
            }
        }

        else if warships[Warship.numberOfShips-1] == shipToHaulOutLast {
            var i = CGFloat.zero
            for ship in warships.reversed() {
                let controlPointBrg = offset - .pi/2
                let controlPoint = CGPoint(x: ship.position.x + 150 * sin(controlPointBrg),
                                           y: ship.position.y + 150 * cos(controlPointBrg))
                let destX = controlPoint.x + (i * CGFloat(300) + CGFloat(150)) * sin(offset)
                let destY = controlPoint.y + (i * CGFloat(300) + CGFloat(150)) * cos(offset)
                let destinationPoint = CGPoint(x: destX, y: destY)
                i += 1
                let pathToDest = UIBezierPath()
                pathToDest.move(to: ship.position)
                pathToDest.addCurve(to: destinationPoint, controlPoint1: controlPoint, controlPoint2: controlPoint)
                let moveAction = SKAction.follow(pathToDest.cgPath, asOffset: false, orientToPath: true, speed: 120)
                let waitAction = SKAction.wait(forDuration: TimeInterval(CGFloat(Warship.numberOfShips)-i) * 2.4)
                ship.run(waitAction, completion: {
                    ship.run(moveAction, completion: {
                        if ship == shipToHaulOutLast {
                            // recalculate and update the formation
                            resultantFormation = FormationCalculator.calculateCurrentFormation(for: warships.toPolarPoints())
                        }
                    })
                })
            }
        }
        else {
            print("error in \(#function)")
        }
        
        return resultantFormation
    }
    
    static func haulOut(to trueBrg: CGFloat, warships: [Warship], refShip: Warship) -> FormationType {
        print("Hauling out to \(trueBrg)")
        let angleInRadians = trueBrg / 180 * .pi
        let offset = -refShip.zRotation
        var projectedX: CGFloat = .zero
        var projectedY: CGFloat = .zero
        var controlPointBrg: CGFloat = .zero
        let refShipIsRoot = refShip == warships[0]
        
        var resultantFormation: FormationType = .none
        
        // check which side is trueBrg on, then calculate the projected position
        if (trueBrg + 360) < (refShip.getAsternBearing() + 210) {
            // project to the right
            projectedX = refShip.position.x + 100 * sin(offset + .pi/2)
            projectedY = refShip.position.y + 100 * cos(offset + .pi/2)
            controlPointBrg = offset + .pi/2
        }
        else if (trueBrg + 360) > (refShip.getAsternBearing() + 510) {
            // project to the left
            projectedX = refShip.position.x + 100 * sin(offset - .pi/2)
            projectedY = refShip.position.y + 100 * cos(offset - .pi/2)
            controlPointBrg = offset - .pi/2
        }
        // for each ship that is not the refship
        for ship in warships {
            let multiplier = abs(refShip.sequenceNum-ship.sequenceNum)
            let newX = projectedX + 150 * sin(angleInRadians) * CGFloat(multiplier)
            let newY = projectedY + 150 * cos(angleInRadians) * CGFloat(multiplier)
            let controlPoint = CGPoint(x: ship.position.x + 100 * sin(controlPointBrg),
                                       y: ship.position.y + 100 * cos(controlPointBrg))
            let pathToDest = UIBezierPath()
            pathToDest.move(to: ship.position)
            pathToDest.addQuadCurve(to: CGPoint(x: newX, y: newY), controlPoint: controlPoint)
            let moveAction = SKAction.follow(pathToDest.cgPath, asOffset: false, orientToPath: true, speed: 120)
            
            var waitAction: SKAction
            if refShipIsRoot {
                waitAction = SKAction.wait(forDuration: TimeInterval(CGFloat(Warship.numberOfShips-ship.sequenceNum)) * 2.4)
            }
            else {
                waitAction = SKAction.wait(forDuration: TimeInterval(CGFloat(ship.sequenceNum-1)) * 2.4)
            }
            
            ship.run(waitAction, completion: {
                ship.run(moveAction, completion: {
                    ship.zRotation = -offset
                    if refShipIsRoot && ship == warships[0] ||
                        !refShipIsRoot && ship == warships.last {
                        // recalculate and update the formation
                        resultantFormation = FormationCalculator.calculateCurrentFormation(for: warships.toPolarPoints())
                    }
                })
            })
        }
        return resultantFormation
    }
    
    // The assumption is that the ref ship is at either end of the formation
    static func haulOutAstern(to trueBrg: CGFloat, warships: [Warship], refShip: Warship) -> FormationType {
        
        var resultantFormation: FormationType = .none
        
        // Control point is 150 units behind reference ship
        let controlPointX: CGFloat = refShip.position.x - 150 * sin(-refShip.zRotation)
        let controlPointY: CGFloat = refShip.position.y - 150 * cos(-refShip.zRotation)
        
        // Calculate the destination point
        let distance = warships.count * 150
        
        
        
        return resultantFormation
        
    }
    
    static func isAngleBetweenRange(angleToCheck: CGFloat, referenceAngle: CGFloat) -> Bool {
        let withinLowerRange: Bool = (angleToCheck + 360) < (referenceAngle + 210)
        let withinUpperRange: Bool = (angleToCheck + 360) > (referenceAngle + 510)
        
        return withinLowerRange || withinUpperRange
    }
}
