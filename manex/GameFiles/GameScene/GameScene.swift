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
    var currentFormation: FormationType? = .one {
        didSet {
            updateShipsPosition()
            updateFormationLabel()
        }
    }
    var lineGuides: [Warship] = []
    // this should give the true bearing of ships from the guide or their line guide
    var formationBearing: CGFloat = 180 {
        didSet {
            print("Ships now bearing \(formationBearing) from their guide")
        }
    }
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
    static let formationCalculator = FormationCalculator()
    
    // MARK: - ENTRY POINT
    override func didMove(to view: SKView) {
        
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
        if let fmn = currentFormation {
            formationLabel.text = "Formation: \(fmn.rawValue)"
        }
        else {
            formationLabel.text = "Formation: None"
        }
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

enum FormationType: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case eleven = "11"
    case twelve = "12"
    case lineOfBearing = "Line of Bearing"
}


