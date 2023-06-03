//
//  MoveShips.swift
//  manex
//
//  Created by michaelyangqianlong on 2/6/23.
//

import SpriteKit

extension GameScene {
    
    func moveShipsTo(newPosition: [CGPoint], excludingIndex excludedIdx: Int) {
        guard newPosition.count == warshipsArray.count else {
            print("debug xyz")

            return
            
        }
        let hdg = warshipsArray[0].zRotation
        for i in 0..<warshipsArray.count {
            if i == excludedIdx {
                continue
            }
            let currShip = warshipsArray[i]
            let path = UIBezierPath()
            path.move(to: currShip.position)
            path.addLine(to: newPosition[i])
            let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 100)
            currShip.run(move, completion: {
                currShip.zRotation = hdg
            })
        }
    }
    
    // moves only a particular subset of ships
    func move(ships: [Warship], to pts: [CGPoint]) {
        guard ships.count == pts.count else { return }
        if pts.count == 0 { return }
        let hdg = ships[0].zRotation
        for i in 0..<pts.count {
            let path = UIBezierPath()
            path.move(to: ships[i].position)
            path.addLine(to: pts[i])
            let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 100)
            ships[i].run(move) {
                ships[i].zRotation = hdg
            }
        }
    }
    
    func haulOutToPort() {
        
    }
    
    func haulOutToStbd() {
        
    }
}
