//
//  Delegates .swift
//  manexapp
//
//  Created by michaelyangqianlong on 26/5/23.
//

import UIKit

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
