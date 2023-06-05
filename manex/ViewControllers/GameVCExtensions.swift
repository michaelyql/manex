//
//  Delegates .swift
//  manexapp
//
//  Created by michaelyangqianlong on 26/5/23.
//

import UIKit
import Instructions

extension GameViewController: GameSceneDelegate {

    func updateNumberOfShips(newVal: Int, lastIndex: Int) {
        for i in 0..<lastIndex {
            let btn = self.referenceShipSelectionMenu.arrangedSubviews[i] as? UIButton
            btn?.isEnabled = true
        }
        for i in lastIndex..<8 {
            let btn = self.referenceShipSelectionMenu.arrangedSubviews[i] as? UIButton
            btn?.isEnabled = false
        }
    }
}

extension GameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Decide whether or not user input will change the text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        var withinRange = true
        // True Bearing text field
        if textField.tag == 0 {
            let num = Int(newString) ?? 0
            withinRange = (num >= 0) && (num <= 359)
        }
        // Rel bearing text field
        else if textField.tag == 1 {
            let num = Int(newString) ?? 0
            withinRange = (num >= 0) && (num <= 180)
        }
        
        var textAllowed = true
        // check the replacement string for valid characters
        if string.count > 0 {
            let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
            textAllowed = (string.rangeOfCharacter(from: disallowedCharacterSet) == nil)
        }
    
        return (newString.count <= maxLength) && textAllowed && withinRange
    }
}

extension GameViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: Instructions.CoachMarksController) -> Int {
        return 9
    }
    
    func coachMarksController(_ coachMarksController: Instructions.CoachMarksController, coachMarkAt index: Int) -> Instructions.CoachMark {
        var coachmark: CoachMark
        switch index {
        case 0:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.toggleOnToolbarButton)
        case 1:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.toolbarView.addShipButton)
        case 2:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.toolbarView.removeShipButton)
        case 3:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.toolbarView.formationButton)
        case 4:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.formationScrollView)
        case 5:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.toolbarView.commandMenuButton)
        case 6:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.commandMenu.segmentedControl)
        case 7:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.referenceShipSelectionMenu)
        case 8:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.toolbarView.infoButton)
        default:
            coachmark = coachMarksController.helper.makeCoachMark()
        }
        
        switch index {
        case 4, 6, 7:
            coachmark.isOverlayInteractionEnabled = true
            coachmark.isUserInteractionEnabledInsideCutoutPath = false
        default:
            coachmark.isOverlayInteractionEnabled = false
            coachmark.isUserInteractionEnabledInsideCutoutPath = true
        }
        
        return coachmark
    }
    
    func coachMarksController(_ coachMarksController: Instructions.CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: Instructions.CoachMark) -> (bodyView: (UIView & Instructions.CoachMarkBodyView), arrowView: (UIView & Instructions.CoachMarkArrowView)?) {
        
        var hintText = ""
        
        switch index {
        case 0:
            hintText = "Tap to open the toolbar."
        case 1:
            hintText = "Tap to add a ship."
        case 2:
            hintText = "Tap to remove a ship."
        case 3:
            hintText = "Tap to select from a list of preset formations."
        case 4:
            hintText = "Preset formations range from 1 to 12."
        case 5:
            hintText = "Tap to bring up the command palette."
        case 6:
            hintText = "Choose from the FORM, CORPEN or TURN commands."
        case 7:
            hintText = "You can also indicate which ship you want ships to form on."
        case 8:
            hintText = "Tap to show more detailed information about the formation, like the current heading."
        default:
            break
        }
                
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation,
            hintText: hintText,
            nextText: nil
        )
        
        coachViews.bodyView.isUserInteractionEnabled = false

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
