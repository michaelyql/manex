//
//  Warship.swift
//  manexapp
//
//  Created by michaelyangqianlong on 8/4/23.
//

import Foundation
import SpriteKit

class Warship: SKSpriteNode {

    // MARK: - PROPERTIES
    static var numberOfShips: Int = 0 {
        didSet {
            gameScene?.updateNumberOfShips(newVal: numberOfShips)
        }
    }
    static var gameScene: WarshipDelegate?
    // Sequence number is the ship's order in the sequence (1-8)
    var sequenceNum: Int
    var standardDistance: CGFloat = 150
    private var sequenceLabel: SKLabelNode
    var warshipHeadingArrow: SKSpriteNode
    
    // for debugging
    override var description: String {
        return self.name!
    }
    
    // MARK: - INIT
    init() {
        let texture = SKTexture(imageNamed: "battleship")
        
        Warship.numberOfShips += 1
        sequenceNum = Warship.numberOfShips
        sequenceLabel = SKLabelNode()
        sequenceLabel.text = "\(self.sequenceNum)"
        sequenceLabel.fontColor = .black
        sequenceLabel.fontSize = 24.0
        sequenceLabel.fontName = "ArialRoundedMTBold"
        sequenceLabel.zPosition = 2
        sequenceLabel.position = CGPoint(x: 0, y: 0)
        sequenceLabel.setScale(2.0)
        
        warshipHeadingArrow = SKSpriteNode(texture: SKTexture(imageNamed: "ship_arrow"))
        warshipHeadingArrow.anchorPoint = CGPoint(x: 0.5, y: 0)
        warshipHeadingArrow.position = CGPoint(x: 0, y: 50)
        warshipHeadingArrow.alpha = 0.0
    
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = "Ship \(sequenceNum)"
        self.setScale(1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(sequenceLabel)
        self.addChild(warshipHeadingArrow)
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Warship.numberOfShips -= 1
    }
    
    func getAsternBearing() -> CGFloat {
        var brg: CGFloat = 0
        brg = round(-self.zRotation / .pi * CGFloat(180) + CGFloat(180)).truncatingRemainder(dividingBy: CGFloat(360))
        return brg
    }
    
    func getTrueHeading() -> CGFloat {
        return round(-self.zRotation / .pi * 180)
    }
}

protocol WarshipDelegate {
    func updateNumberOfShips(newVal: Int)
}
