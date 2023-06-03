//
//  ToolbarButton.swift
//  manexapp
//
//  Created by michaelyangqianlong on 26/5/23.
//

import UIKit

class ToolbarButton: UIButton {
    
    required init(imageForNormalState: UIImage?, imageForSelectedState: UIImage? = nil) {
        super.init(frame: .zero)
        
        setImage(imageForNormalState, for: .normal)
        let lightWeight = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        setPreferredSymbolConfiguration(lightWeight, forImageIn: .normal)
        
        if imageForSelectedState != nil {
            setImage(imageForSelectedState, for: .selected)
            setPreferredSymbolConfiguration(lightWeight, forImageIn: .selected)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
