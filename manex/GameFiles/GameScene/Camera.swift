//
//  CameraUtilities.swift
//  manexapp
//
//  Created by michaelyangqianlong on 27/5/23.
//

import SpriteKit

extension GameScene {
    
    func getFormationCentroid() -> CGPoint {
        var cenX = CGFloat.zero
        var cenY = CGFloat.zero
        for ship in warshipsArray {
            cenX += ship.position.x
            cenY += ship.position.y
        }
        cenX = cenX / CGFloat(warshipsArray.count)
        cenY = cenY / CGFloat(warshipsArray.count)
        return CGPoint(x: cenX, y: cenY)
    }
    func moveCamera(to newPoint: CGPoint ) {
        guard let camera = self.camera else { return }
        camera.position = newPoint
    }
    func lockCamera(on node: SKSpriteNode) {
        guard let camera = self.camera else { return }
        let zeroRange = SKRange(constantValue: 0)
        let lockToNode = SKConstraint.distance(zeroRange, to: node)
        camera.constraints = [lockToNode]
    }
    func unlockCamera() {
        guard let camera = self.camera else { return }
        camera.constraints = nil
    }
}
