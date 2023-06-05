//
//  GameViewController.swift
//  manexapp
//
//  Created by michaelyangqianlong on 7/4/23.
//

import UIKit
import SpriteKit
import Instructions

class GameViewController: UIViewController {

    // MARK: - PROPERTIES
    // views
    weak var skView: SKView!
    weak var gameScene: GameScene!
    weak var toolbarView: ToolbarView!
    weak var formationScrollView: FormationScrollView!
    weak var toggleOnToolbarButton: ToggleToolbar!
    weak var turnButton: UIButton!
    weak var commandMenu: CommandMenu!
    weak var currentReferenceShip: UIButton!
    weak var referenceShipSelectionMenu: UIStackView!
    // flags
    var isToolbarShowing: Bool = false
    var isFormationScrollViewShowing: Bool = false
    var isInfoViewShowing: Bool = false
    var isCommandMenuShowing: Bool = false
    // coachmarks
    let coachMarksController = CoachMarksController()
    var isCoachMarkShowing: Bool = false
    
    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView()
        self.skView = skView
        view = skView
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            self.gameScene = scene
            
            // Don't use aspectFit or aspectFill because it leads to wrong view size
            scene.scaleMode = .resizeFill
            scene.backgroundColor = UIColor(red: 140/255, green: 170/255, blue: 180/255, alpha: 1.0)
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
            
            title = ""
            
            setupToolbar()
            setupToolbarToggleOnButton()
            setupFormationScrollView()
            setupCommandMenu()
            
            coachMarksController.dataSource = self
            coachMarksController.overlay.isUserInteractionEnabled = true
            coachMarksController.overlay.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.coachMarksController.start(in: .window(over: self))
        self.isCoachMarkShowing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.coachMarksController.stop(immediately: true)
        self.isCoachMarkShowing = false
    }
}
