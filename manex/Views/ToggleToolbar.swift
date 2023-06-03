//
//  ToggleToolbar.swift
//  manex
//
//  Created by michaelyangqianlong on 28/5/23.
//

import UIKit

class ToggleToolbar: UIButton {
    
    required init(target: Any?, action: Selector) {
        super.init(frame: .zero)
        
        self.addTarget(target, action: action, for: .touchUpInside)
        self.setImage(UIImage(systemName: "dock.rectangle"), for: .normal)
        let largeCfg = UIImage.SymbolConfiguration(scale: .large)
        self.setPreferredSymbolConfiguration(largeCfg, forImageIn: .normal)
        self.tintColor = .tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}
