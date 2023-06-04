//
//  ObjcFunctions.swift
//  manexapp
//
//  Created by michaelyangqianlong on 26/5/23.
//

import UIKit

extension GameViewController {
    
    @objc func dummyfunc() {
        print("testing 123")
    }
    
    // MARK: - TOOLBAR
    
    @objc func didTapToggleOnToolbarButton() {
        if !isToolbarShowing {
            UIView.animate(withDuration: 0.3) {
                self.toolbarView.alpha = 1.0
                self.toggleOnToolbarButton.alpha = 0.0
            }
            isToolbarShowing.toggle()
        }
    }
    
    @objc func didTapToggleOffToolbarButton() {
        if isToolbarShowing {
            UIView.animate(withDuration: 0.3) {
                self.toolbarView.alpha = 0.0
                self.toggleOnToolbarButton.alpha = 1.0
            }
            isToolbarShowing.toggle()
        }
        if isFormationScrollViewShowing {
            UIView.animate(withDuration: 0.3) {
                self.formationScrollView.alpha = 0.0
            }
            isFormationScrollViewShowing.toggle()
        }
    }
    
    @objc func didTapAddShipButton() {
        gameScene.addShip()
    }
    
    @objc func didTapRemoveShipButton() {
        gameScene.removeShip()
    }
    
    @objc func toggleTurnButton() {
        toolbarView.turnButton.isSelected.toggle()
        gameScene.isTurnButtonEnabled = toolbarView.turnButton.isSelected
    }
    
    @objc func didTapInfoButton() {
        isInfoViewShowing.toggle()
        gameScene.toggleInfoView(isShowing: isInfoViewShowing)
    }
    
    // MARK: - FORMATION SCROLL VIEW
    @objc func didTapFormationButton() {
        // hide other menus
        if isCommandMenuShowing {
            commandMenu.alpha = 0.0
            referenceShipSelectionMenu.alpha = 0.0
            isCommandMenuShowing.toggle()
        }
        // toggle formation menu
        if !isFormationScrollViewShowing {
            UIView.animate(withDuration: 0.3) {
                self.formationScrollView.alpha = 1.0
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.formationScrollView.alpha = 0.0
            }
        }
        isFormationScrollViewShowing.toggle()
    }
    
    @objc func didTapFormationOptionsButton() {
        print("tapped fmn option button")
    }
    
    @objc func showFormation(sender: UIButton) {
        gameScene.updateFormation(number: sender.tag)
    }
    
    // MARK: - COMMAND MENU
    @objc func didTapCommandMenuButton() {
        // hide other menus
        if isFormationScrollViewShowing {
            formationScrollView.alpha = 0.0
            isFormationScrollViewShowing.toggle()
        }
        // toggle command menu
        if !isCommandMenuShowing {
            commandMenu.alpha = 1.0
            if commandMenu.segmentedControl.selectedSegmentIndex == 0 {
                referenceShipSelectionMenu.alpha = 1.0
            }
        }
        else {
            commandMenu.alpha = 0.0
            referenceShipSelectionMenu.alpha = 0.0
        }
        isCommandMenuShowing.toggle()
    }
    
    @objc func commandMenuValueDidChange(_ sender: UISegmentedControl) {
        commandMenu.bringMenuViewToFront(segmentIndex: sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            referenceShipSelectionMenu.alpha = 1.0
        }
        else {
            referenceShipSelectionMenu.alpha = 0.0
        }
    }
    
    // Whenever text field changes, disable/reset the other text fields
    @objc func formationTextFieldsDidChange(_ textField: UITextField) {
        commandMenu.formationView.updateTextFields(activeTextFieldTag: textField.tag)
    }
    
    @objc func turnTextFieldsDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.commandMenu.turnView.relDirSegmentControl.selectedSegmentIndex = -1
            self.commandMenu.turnView.relDirSegmentControl.isEnabled = false
            self.commandMenu.turnView.relBrgTextField.text = nil
        case 1:
            self.commandMenu.turnView.relDirSegmentControl.isEnabled = true
            self.commandMenu.turnView.trueBrgTextField.text = nil
        default:
            break
        }
    }
    
    // dismiss keyboard, end editing
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    @objc func executeFormation() {
        // hide menu and dismiss keyboard
        self.commandMenu.alpha = 0.0
        self.isCommandMenuShowing = false
        self.referenceShipSelectionMenu.alpha = 0.0
        self.view.endEditing(true)
        
        let userInputs = getFormationViewUserInputs()
        let refShip = gameScene.warshipsArray[currentReferenceShip.tag] // tag is from 0-7
        gameScene.executeFormations(with: userInputs, withReferenceTo: refShip)
        
        // pass user input to game scene
        return 
        guard currentReferenceShip.tag <= Warship.numberOfShips else { return }
        if let scene = skView.scene as? GameScene {
            if let trueBrgText = self.commandMenu.formationView.trueBrgTextField.text,
                let trueBrg = Double(trueBrgText) {
                scene.executeFormation(isFormGOn: self.commandMenu.formationView.golfSwitch.isOn,
                                       trueBrg: CGFloat(trueBrg),
                                       relativeDir: -1,
                                       relBrg: nil,
                                       divSeparation: self.commandMenu.formationView.divSegmentControl.selectedSegmentIndex,
                                       refShipIndex: currentReferenceShip.tag)
            }
            else if let relBrgText = self.commandMenu.formationView.relBrgTextField.text,
                        let relBrg = Double(relBrgText) {
                scene.executeFormation(isFormGOn: self.commandMenu.formationView.golfSwitch.isOn,
                                       trueBrg: nil,
                                       relativeDir: self.commandMenu.formationView.relDirSegmentControl.selectedSegmentIndex,
                                       relBrg: CGFloat(relBrg),
                                       divSeparation: self.commandMenu.formationView.divSegmentControl.selectedSegmentIndex,
                                       refShipIndex: currentReferenceShip.tag)
            }
        }
    }
    
    func getFormationViewUserInputs() -> FormationInputs {
        return commandMenu.formationView.getUserInputs()
    }
    
    @objc func executeCorpen() {
        // hide menu and dismiss keyboard
        self.commandMenu.alpha = 0.0
        self.isCommandMenuShowing = false
        self.view.endEditing(true)
        
        // pass in user input
        if let scene = skView.scene as? GameScene {
            if let trueBrgText = self.commandMenu.corpenView.trueBrgTextField.text,
                let trueBrg = Double(trueBrgText) {
                scene.executeCorpen(isCorpenDOn: self.commandMenu.corpenView.deltaSwitch.isOn, trueBrg: CGFloat(trueBrg))
            }
        }
    }
    
    @objc func executeTurn() {
        // hide menu and dismiss keyboard
        self.commandMenu.alpha = 0.0
        self.isCommandMenuShowing = false
        self.view.endEditing(true)
        
        // pass in user input
        if let scene = skView.scene as? GameScene {
            if let trueBrgText = self.commandMenu.turnView.trueBrgTextField.text,
                let trueBrg = Double(trueBrgText) {
                scene.executeTurn(trueBrg: CGFloat(trueBrg),
                                  relativeDir: self.commandMenu.turnView.relDirSegmentControl.selectedSegmentIndex,
                                  relBrg: nil)
            }
            else if let relBrgText = self.commandMenu.turnView.relBrgTextField.text,
                        let relBrg = Double(relBrgText) {
                scene.executeTurn(trueBrg: nil,
                                  relativeDir: self.commandMenu.turnView.relDirSegmentControl.selectedSegmentIndex,
                                  relBrg: CGFloat(relBrg))
            }
        }
    }
    
    @objc func resetCommandMenu() {
        commandMenu.clearAllInputs()
    }
    
    @objc func referenceShipSelectionDidChange(_ sender: UIButton) {
        if sender != currentReferenceShip {
            currentReferenceShip.isSelected = false
            sender.isSelected = true
            currentReferenceShip = sender
        }
    }
    
}