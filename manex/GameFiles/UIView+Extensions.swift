//
//  UIViewExtensions.swift
//  manexapp
//
//  Created by michaelyangqianlong on 19/4/23.
//

import Foundation
import UIKit

extension UIView {
    
    // Get parent view controller from any view
    func getParentViewController() -> UIViewController {
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
}
