//
//  ToolbarView.swift
//  manexapp
//
//  Created by michaelyangqianlong on 26/5/23.
//

import UIKit

class ToolbarView: UIStackView {
    
    weak var toggleOffButton: ToolbarButton!
    weak var addShipButton: ToolbarButton!
    weak var removeShipButton: ToolbarButton!
    weak var formationButton: ToolbarButton!
    weak var turnButton: ToolbarButton!
    weak var commandMenuButton: ToolbarButton!
    weak var infoButton: ToolbarButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
        backgroundColor = .white
        layer.cornerRadius = 15
        alpha = 0.0
        
        let toggleOffButton = ToolbarButton(imageForNormalState: UIImage(systemName: "xmark"))
        let addShipButton = ToolbarButton(imageForNormalState: UIImage(systemName: "plus.circle"))
        let removeShipButton = ToolbarButton(imageForNormalState: UIImage(systemName: "minus.circle"))
        let formationButton = ToolbarButton(imageForNormalState: UIImage(systemName: "f.circle"))
        let turnButton = ToolbarButton(imageForNormalState: UIImage(systemName: "t.circle"), imageForSelectedState: UIImage(systemName: "t.circle.fill"))
        let commandMenuButton = ToolbarButton(imageForNormalState: UIImage(systemName: "arrow.right.circle"))
        let infoButton = ToolbarButton(imageForNormalState: UIImage(systemName: "info.circle"))
        
        self.toggleOffButton = toggleOffButton
        self.addShipButton = addShipButton
        self.removeShipButton = removeShipButton
        self.formationButton = formationButton
        self.turnButton = turnButton
        self.commandMenuButton = commandMenuButton
        self.infoButton = infoButton
        
        for button in [toggleOffButton, addShipButton, removeShipButton, formationButton, turnButton, commandMenuButton, infoButton] {
            addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not implemented")
    }
}
