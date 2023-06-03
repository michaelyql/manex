//
//  CommandMenuButtons.swift
//  manexapp
//
//  Created by michaelyangqianlong on 27/5/23.
//

import UIKit

class ResetButton: UIButton {
    
    required init() {
        super.init(frame: .zero)
        
        self.setTitle("Reset", for: .normal)
        self.tintColor = .systemBlue
        self.configuration = .plain()
        self.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExecuteButton: UIButton {
    
    required init() {
        super.init(frame: .zero)
        
        self.setTitle("Execute", for: .normal)
        self.tintColor = .systemBlue
        self.configuration = .filled()
        self.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
