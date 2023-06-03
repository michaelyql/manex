//
//  ContainerViewController.swift
//  manexapp
//
//  Created by michaelyangqianlong on 22/4/23.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    let menuVC: MenuViewController = MenuViewController()
    let homeVC: HomeViewController = HomeViewController()
    var navVC: UINavigationController?
    lazy var settingsVC: SettingsViewController = SettingsViewController()
    lazy var gameVC: GameViewController = GameViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVCs()
        
    }
    
    func addChildVCs() {
        // Add menu VC view below
        addChild(menuVC)
        view.addSubview(menuVC.view)

        // For custom container VCs, always call didMove(toParent:) after adding VC as a child of another VC
        menuVC.didMove(toParent: self)
        // MenuVC will notify the container VC when one of its table view cells has been tapped
        // MenuVC passes which cell has been tapped by the MenuOption enum
        // Based on the MenuOption passed, we use a switch statement to figure out which VC to present
        // From the container VC
        menuVC.delegate = self
        menuVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            menuVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuVC.view.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        // Add Nav VC on top of menu VC
        // Menu VC is only revealed when Nav VC is translated to the right
        let navVC = UINavigationController(rootViewController: homeVC)
        self.navVC = navVC
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        
        // Menu Button is defined in homeVC's navigation item bar button
        // So whenver the button is pressed in HomeVC, it tells its delegate (i.e. Container VC)
        // That the menu button was pressed
        // Container VC is responsible for shifting the Nav VC to the right
        homeVC.delegate = self

    }
    
    // Method inherited from UITraitEnvironment protocol, called when interface environment changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update frame of view currently at the top of the stack to match the interface orientation
        // Previously the frame would be stuck at the previous interface orientation
//        self.homeVC.children.last?.view.frame = view.frame
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        // Button is being pressed from HomeViewController
        // This means user only wants to show/hide the menu
        // No need to present any new VCs, therefore no completion block is needed
        // Simply show/hide the menu
        toggleMenu(completion: nil)
    }
    
    // Toggle Menu applies for when user taps on the Menu Icon Button in Home VC
    // It also fires whenever user taps on a cell in the menu's Table View
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            self.menuState = .opened

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.navVC?.view.frame.origin.x += 200
                
            } completion: { done in
                // Completion code is currently not necessary
                if done {
                }

            }
        case .opened:
            self.menuState = .closed

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.navVC?.view.frame.origin.x = 0
                
            } completion: { done in
                // Completion code is currently not necessary
                if done {
                    // Run completion on main queue asynchronously
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    
    // MenuVC tells ContainerVC which cell was tapped based on its enum value (MenuOption)
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        
        // After toggling the side menu,
        toggleMenu(completion: nil)
        
        // Present a new VC based on the menu item selected
        // Every time you add a new cell i.e. new menu item, remember to update here as well
        switch menuItem {
                
        case .home:
            self.resetToHome()
        case .manex:
            self.presentManexVC()
        case .settings:
            self.presentSettingsVC()
        }
    }
    
    func resetToHome() {
        removeAllViewControllers()
        homeVC.title = ""
    }
    
    func presentManexVC() {
        removeAllViewControllers()
        let manexVC = gameVC
        homeVC.addChild(manexVC)
        homeVC.view.addSubview(manexVC.view)
        manexVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            manexVC.view.leadingAnchor.constraint(equalTo: homeVC.view.leadingAnchor),
            manexVC.view.trailingAnchor.constraint(equalTo: homeVC.view.trailingAnchor),
            manexVC.view.topAnchor.constraint(equalTo: homeVC.view.topAnchor),
            manexVC.view.bottomAnchor.constraint(equalTo: homeVC.view.bottomAnchor)
        ])
        manexVC.didMove(toParent: homeVC)
        homeVC.title = ""
    }
    
    func presentSettingsVC() {
        // Whenever you want to present a new VC, remember to:
        // 1. Add the new VC as a child of the container VC
        // 2. Add the new VC's view as a subview of the parent VC's root view
            
        /*
         In this case, we are adding the new VC as a child to HomeVC instead of ContainerVC.
         This is because the Navigation bar (i.e. the Nav VC's view) is also a child of ContainerVC.
         If we add the new VC as a child to the ContainerVC, the new VC (and it's view) will be covering
         the NavVC's view (i.e. the navigation bar, and subsequently the homeVC's menu bar item)
         since it was added later (and therefore higher up on the stack).
         Therefore the navVC's view will be covered and will not be visible.
        */
        removeAllViewControllers()
        let vc = settingsVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
        homeVC.title = vc.title  
    }
    
    func removeAllViewControllers() {
        if homeVC.children.count > 0 {
            let vcs = homeVC.children
            vcs.last?.willMove(toParent: nil)
            vcs.last?.view.removeFromSuperview()
            vcs.last?.removeFromParent()
        }
    }
}
