//
//  KeyboardAccessoryToolbar.swift
//  manexapp
//
//  Created by michaelyangqianlong on 27/5/23.
//

import UIKit

class KeyboardToolbar: UIToolbar {
    
    convenience init(target: Any?, action: Selector) {
        self.init(frame: CGRect.zero)
        
        self.barStyle = .default
        self.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: target, action: action),
        ]
        self.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
