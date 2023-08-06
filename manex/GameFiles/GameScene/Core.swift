//
//  FormationFunctions .swift
//  manexapp
//
//  Created by michaelyangqianlong on 15/5/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func addShip() {
        // if current formation is nil, don't let them add a new ship
        if Warship.numberOfShips > 7 || currentFormation == .none {
            return
        }
        else {
            let warship = Warship()
            warshipsArray.append(warship)
            // New warship should be facing in same direction as all the other ships
            warship.zRotation = warshipsArray[warship.sequenceNum-2].zRotation
            addChild(warship)
            updateShipsPosition()
        }
    }
        
    func removeShip() {
        if Warship.numberOfShips < 2 {
            return
        }
        else {
            let temp = warshipsArray.remove(at: Warship.numberOfShips-1)
            temp.removeFromParent()
        }
        // update camera position so user doesn't have to pan to find where are the ships
        let newCameraPosition: CGPoint = getFormationCentroid()
        moveCamera(to: newCameraPosition)
        updateShipsPosition()
    }
    
    func updateShipsPosition() {
        switch currentFormation {
        case .one:
            formation1()
        case .two:
            formation2()
        case .three:
            formation3()
        case .four:
            formation4()
        case .five:
            formation5()
        case .six:
            formation6()
        case .seven:
            formation7()
        case .eight:
            formation8()
        case .nine:
            formation9()
        case .ten:
            formation10()
        case .eleven:
            formation11()
        case .twelve:
            formation12()
        case .lineOfBearing(let bearing):
            truelineOfBearing(bearing)
        case .none:
            break
        }
        let newCameraPosition: CGPoint = getFormationCentroid()
        moveCamera(to: newCameraPosition)
    }
    
    // column in order of callsign
    func formation1() {
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(180 + offset)
    }
    // column in reverse order
    func formation2() {
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(0 + offset)
    }
    // line abreast to stbd
    func formation3() {
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(90 + offset)
    }
    // line abreast to port
    func formation4() {
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(270 + offset)
    }
    // div in column, div guides bearing abeam to stbd
    func formation5() {
        let midpoint = Warship.numberOfShips % 2 == 0 ? Warship.numberOfShips/2 : (Warship.numberOfShips+1) / 2
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(180 + offset, end: midpoint)
        truelineOfBearingWithOffset(180 + offset, start: midpoint, xOffset: 300)
    }
    // div in column, div guides bearing abeam to port
    func formation6() {
        let midpoint = Warship.numberOfShips % 2 == 0 ? Warship.numberOfShips/2 : (Warship.numberOfShips+1) / 2
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(180 + offset, end: midpoint)
        truelineOfBearingWithOffset(180 + offset, start: midpoint, xOffset: -300)
    }
    // subdiv in column, subdiv guides bearing abeam to stbd
    func formation7() {
        let offset = -warshipsArray[0].zRotation
        for i in 1..<Warship.numberOfShips {
            if i % 2 != 0 {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-1]
                curr.position.x = prev.position.x - 150 * sin(offset)
                curr.position.y = prev.position.y + 150 * cos(.pi + offset)
            }
            else {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-2]
                curr.position.x = prev.position.x + 300 * cos(offset)
                curr.position.y = prev.position.y - 300 * sin(offset)
            }
            warshipsArray[i].zRotation = warshipsArray[i-1].zRotation
        }
    }
    // subdiv in column, subdiv guides bearing abeam to port
    func formation8() {
        let offset = -warshipsArray[0].zRotation
        for i in 1..<Warship.numberOfShips {
            if i % 2 != 0 {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-1]
                curr.position.x = prev.position.x - 150 * sin(offset)
                curr.position.y = prev.position.y + 150 * cos(.pi + offset)
            }
            else {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-2]
                curr.position.x = prev.position.x - 300 * cos(offset)
                curr.position.y = prev.position.y + 300 * sin(offset)
            }
            warshipsArray[i].zRotation = warshipsArray[i-1].zRotation
        }
    }
    // div line abreast to stbd, div guides bearing astern
    func formation9() {
        let midpoint = Warship.numberOfShips % 2 == 0 ? Warship.numberOfShips/2 : (Warship.numberOfShips+1) / 2
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(90 + offset, end: midpoint)
        truelineOfBearingWithOffset(90 + offset, start: midpoint, yOffset: -300)
    }
    // div line abreast to port, div guides bearing astern
    func formation10() {
        let midpoint = Warship.numberOfShips % 2 == 0 ? Warship.numberOfShips/2 : (Warship.numberOfShips+1) / 2
        let offset = -warshipsArray[0].zRotation / .pi * 180
        truelineOfBearing(270 + offset, end: midpoint)
        truelineOfBearingWithOffset(270 + offset, start: midpoint, yOffset: -300)
    }
    // subdiv line abreast to stbd, subdiv guides bearing astern
    func formation11() {
        let offset = -warshipsArray[0].zRotation
        for i in 1..<Warship.numberOfShips {
            if i % 2 != 0 {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-1]
                curr.position.x = prev.position.x + 150 * cos(offset)
                curr.position.y = prev.position.y - 150 * sin(offset)
            }
            else {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-2]
                curr.position.x = prev.position.x - 300 * sin(offset)
                curr.position.y = prev.position.y + 300 * cos(.pi + offset)
            }
            warshipsArray[i].zRotation = warshipsArray[i-1].zRotation
        }
    }
    // subdiv line abreast to port, subdiv guides bearing astern
    func formation12() {
        let offset = -warshipsArray[0].zRotation
        for i in 1..<Warship.numberOfShips {
            if i % 2 != 0 {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-1]
                curr.position.x = prev.position.x - 150 * cos(offset)
                curr.position.y = prev.position.y + 150 * sin(offset)
            }
            else {
                let curr = warshipsArray[i]
                let prev = warshipsArray[i-2]
                curr.position.x = prev.position.x - 300 * sin(offset)
                curr.position.y = prev.position.y + 300 * cos(.pi + offset)
            }
            warshipsArray[i].zRotation = warshipsArray[i-1].zRotation
        }
    }
    // start and end are the indices of the ship to start and end at respectively
    func truelineOfBearing(_ angle: CGFloat, start: Int = 1, end: Int = Warship.numberOfShips) {
        let angleInRad = angle * .pi / 180
        for i in start..<end {
            let curr = warshipsArray[i]
            let prev = warshipsArray[i-1]
            curr.position = CGPoint(x: prev.position.x + 150 * sin(angleInRad),
                                    y: prev.position.y + 150 * cos(angleInRad))
            curr.zRotation = prev.zRotation
        }
    }
    // warshipsArray[start] will be the ship being offset by either its X or Y pos
    func truelineOfBearingWithOffset(_ angle: CGFloat, start: Int = 1, end: Int = Warship.numberOfShips, xOffset: Double = 0, yOffset: Double = 0) {
        
        guard Warship.numberOfShips > 1 else { return }
        
        let angleInRad = angle * .pi / 180
        let angleOffset = -warshipsArray[0].zRotation
        let idxOffset = end % 2 == 0 ? (end-start) : (end-start+1)
        if xOffset != 0 {
            let startShip = warshipsArray[start]
            let refShip = warshipsArray[start-idxOffset]
            startShip.position = CGPoint(x: refShip.position.x + xOffset * cos(CGFloat(angleOffset)),
                                         y: refShip.position.y - xOffset * sin(CGFloat(angleOffset)))
        }
        else if yOffset != 0 {
            let startShip = warshipsArray[start]
            let refShip = warshipsArray[start-idxOffset]
            startShip.position = CGPoint(x: refShip.position.x + yOffset * sin(CGFloat(angleOffset)),
                                         y: refShip.position.y + yOffset * cos(CGFloat(angleOffset)))
        }
        warshipsArray[start].zRotation = warshipsArray[start-idxOffset].zRotation
        for i in (start+1)..<end {
            let curr = warshipsArray[i]
            let prev = warshipsArray[i-1]
            curr.position = CGPoint(x: prev.position.x + 150 * sin(angleInRad),
                                    y: prev.position.y + 150 * cos(angleInRad))
            curr.zRotation = prev.zRotation
        }
    }
    
    func updateFormation(number: Int) {
        switch number {
        case 1:
            self.currentFormation = .one
        case 2:
            self.currentFormation = .two
        case 3:
            self.currentFormation = .three
        case 4:
            self.currentFormation = .four
        case 5:
            self.currentFormation = .five
        case 6:
            self.currentFormation = .six
        case 7:
            self.currentFormation = .seven
        case 8:
            self.currentFormation = .eight
        case 9:
            self.currentFormation = .nine
        case 10:
            self.currentFormation = .ten
        case 11:
            self.currentFormation = .eleven
        case 12:
            self.currentFormation = .twelve
        default:
            self.currentFormation = .none
        }
    }
}
