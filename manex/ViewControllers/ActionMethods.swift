//
//  ObjcFunctions.swift
//  manexapp
//
//  Created by michaelyangqianlong on 26/5/23.
//

import UIKit
import Instructions

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
        
        // coachmarks
        if isCoachMarkShowing {
            self.coachMarksController.flow.showNext()
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
        
        // coachmarks
        if isCoachMarkShowing {
            self.coachMarksController.flow.showNext()
        }
    }
    
    @objc func didTapRemoveShipButton() {
        gameScene.removeShip()
        
        // coachmarks
        if isCoachMarkShowing {
            self.coachMarksController.flow.showNext()
        }
    }
    
    @objc func toggleTurnButton() {
        toolbarView.turnButton.isSelected.toggle()
        gameScene.isTurnButtonEnabled = toolbarView.turnButton.isSelected
    }
    
    @objc func didTapInfoButton() {
        isInfoViewShowing.toggle()
        gameScene.toggleInfoView(isShowing: isInfoViewShowing)
        
        // coachmarks
        if isCoachMarkShowing {
            self.coachMarksController.flow.showNext()
        }
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
        
        // coachmarks
        if isCoachMarkShowing {
            self.coachMarksController.flow.showNext()
        }
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
        
        // coachmarks
        if isCoachMarkShowing {
            self.coachMarksController.flow.showNext()
        }
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
        gameScene.executeFormation(with: userInputs, withReferenceTo: refShip)
    }
    
    private func getFormationViewUserInputs() -> FormationInputs {
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
        
        let userInputs = getTurnViewUserInputs()
        gameScene.executeTurn(with: userInputs)
    }
    
    private func getTurnViewUserInputs() -> TurnInputs {
        return commandMenu.turnView.getUserInputs()
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
