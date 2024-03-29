//
//  GameScene.swift
//  manexapp
//
//  Created by michaelyangqianlong on 7/4/23.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate {
    func updateNumberOfShips(newVal: Int, lastIndex: Int)
}

class GameScene: SKScene {
    
    // MARK: - PROPERTIES
    var warshipsArray: [Warship] = []
    var currentFormation: FormationType = .one {
        didSet {
            updateShipsPosition()
            updateFormationLabel()
            print("[GameScene.swift] Formation Updated.")
        }
    }
    var lineGuides: [Warship] = []
    var gameVC: GameViewController?
    var prevWheelAngle: CGFloat = 0.0
    var prevShipHeading: CGFloat = 0.0
    var isTurnButtonEnabled: Bool = false
    var previousCameraPoint: CGPoint = CGPoint.zero
    var previousCameraScale: CGFloat = CGFloat.zero
    let minCameraScale: CGFloat = 1.0
    let maxCameraScale: CGFloat = 3.0
    let degreeWheel: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "degree_wheel"))
    let degreeWheelArrow: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "arrow"))
    let degreeWheelAngleLabel: SKLabelNode = SKLabelNode(text: "Heading: 000")
    let headingLabel: SKLabelNode = SKLabelNode(text: "Heading: 000")
    let formationLabel: SKLabelNode = SKLabelNode(text: "Formation: 1")
    let numberOfShipsLabel: SKLabelNode = SKLabelNode(text: "No. of Ships: 1")
    let TURN_DURATION: CGFloat = 1.0
    let utils: CommandUtils = CommandUtils()
    
    // MARK: - ENTRY POINT
    override func didMove(to view: SKView) {
        
        utils.setGameScene(self)
        
        let ship = Warship()
        warshipsArray.append(ship)
        addChild(ship)
            
        // Connect delegates
        Warship.gameScene = self
        let parent = view.getParentViewController() as? GameViewController
        gameVC = parent
        
        setupCamera()
        setupDegreeWheel()
        setupInfoView()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        if oldSize.width > oldSize.height || oldSize.width == oldSize.height {
            headingLabel.position = CGPoint(x: -175, y: 300)
            formationLabel.position = CGPoint(x: -175, y: 275)
            numberOfShipsLabel.position = CGPoint(x: -175, y: 250)
        }
        else {
            headingLabel.position = CGPoint(x: -350, y: 125)
            formationLabel.position = CGPoint(x: -350, y: 100)
            numberOfShipsLabel.position = CGPoint(x: -350, y: 75)
        }
    }
    
    func updateFormationLabel() {
        formationLabel.text = "Formation: \(currentFormation)"
    }
    
    func toggleInfoView(isShowing: Bool) {
        if isShowing {
            headingLabel.alpha = 1.0
            formationLabel.alpha = 1.0
            numberOfShipsLabel.alpha = 1.0
            for ship in warshipsArray {
                ship.warshipHeadingArrow.alpha = 1.0
            }
        }
        else {
            headingLabel.alpha = 0.0
            formationLabel.alpha = 0.0
            numberOfShipsLabel.alpha = 0.0
            for ship in warshipsArray {
                ship.warshipHeadingArrow.alpha = 0.0
            }
        }
    }
}

extension GameScene: WarshipDelegate {
    func updateNumberOfShips(newVal: Int) {
        numberOfShipsLabel.text = "No. of Ships: \(newVal)"
        gameVC?.updateNumberOfShips(newVal: newVal, lastIndex: newVal)
    }
}
