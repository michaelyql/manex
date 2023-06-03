//
//  GameViewControllerHelper.swift
//  manexapp
//
//  Created by michaelyangqianlong on 23/4/23.
//

import Foundation
import UIKit

// MARK: - SETUP 
extension GameViewController {
        
    func setupToolbar() {
        let toolbarView = ToolbarView()
        self.toolbarView = toolbarView
        view.addSubview(toolbarView)
        
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            toolbarView.widthAnchor.constraint(equalToConstant: 350),
            toolbarView.heightAnchor.constraint(equalToConstant: 55)
        ])

        toolbarView.toggleOffButton.addTarget(self, action: #selector(didTapToggleOffToolbarButton), for: .touchUpInside)
        toolbarView.addShipButton.addTarget(self, action: #selector(didTapAddShipButton), for: .touchUpInside)
        toolbarView.removeShipButton.addTarget(self, action: #selector(didTapRemoveShipButton), for: .touchUpInside)
        toolbarView.formationButton.addTarget(self, action: #selector(didTapFormationButton), for: .touchUpInside)
        toolbarView.turnButton.addTarget(self, action: #selector(toggleTurnButton), for: .touchUpInside)
        toolbarView.commandMenuButton.addTarget(self, action: #selector(didTapCommandMenuButton), for: .touchUpInside)
        toolbarView.infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
    }
    
    func setupToolbarToggleOnButton() {
        let toggleOnToolbarButton = ToggleToolbar(target: self, action: #selector(didTapToggleOnToolbarButton))
        self.toggleOnToolbarButton = toggleOnToolbarButton
        view.addSubview(toggleOnToolbarButton)
        toggleOnToolbarButton.translatesAutoresizingMaskIntoConstraints = false
        toggleOnToolbarButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        toggleOnToolbarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    }
    
    func setupFormationScrollView() {
        let formationScrollView = FormationScrollView()
        self.formationScrollView = formationScrollView
        view.addSubview(formationScrollView)
        formationScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formationScrollView.widthAnchor.constraint(equalToConstant: 350),
            formationScrollView.heightAnchor.constraint(equalToConstant: 55),
            formationScrollView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor, constant: -10),
            formationScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        for view in formationScrollView.buttonStack.arrangedSubviews {
            let button = view as! UIButton
            button.addTarget(self, action: #selector(showFormation(sender:)), for: .touchUpInside)
        }
        
        formationScrollView.optionsButton.addTarget(self, action: #selector(didTapFormationOptionsButton), for: .touchUpInside)
    }
    
    func setupCommandMenu() {
        let commandMenu = CommandMenu()
        self.commandMenu = commandMenu
        view.addSubview(commandMenu)
        commandMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commandMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commandMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            commandMenu.widthAnchor.constraint(equalToConstant: 250),
            commandMenu.heightAnchor.constraint(equalToConstant: 260)
        ])
        connectActionMethodsAndDelegates()
        
        // TODO: - create separate class for selection menu
        // TODO: link the change in number of ships to change in selectable ships in menu
        let referenceShipSelectionMenu = UIStackView()
        self.referenceShipSelectionMenu = referenceShipSelectionMenu
        self.view.addSubview(referenceShipSelectionMenu)
        referenceShipSelectionMenu.axis = .vertical
        referenceShipSelectionMenu.distribution = .fillEqually
        referenceShipSelectionMenu.alignment = .fill
        referenceShipSelectionMenu.backgroundColor = .white
        referenceShipSelectionMenu.layer.cornerRadius = 8
        referenceShipSelectionMenu.translatesAutoresizingMaskIntoConstraints = false
        referenceShipSelectionMenu.alpha = 0.0
        // Be careful when setting the height and width of UIViews based on other view's frame's height and width
        // If the other view has a frame height or width or 0, the view will not show since you are also setting its height or width to 0
        NSLayoutConstraint.activate([
            referenceShipSelectionMenu.leadingAnchor.constraint(equalTo: commandMenu.formationView.trailingAnchor, constant: 10),
            referenceShipSelectionMenu.bottomAnchor.constraint(equalTo: commandMenu.formationView.bottomAnchor),
            referenceShipSelectionMenu.widthAnchor.constraint(equalToConstant: 40),
            referenceShipSelectionMenu.heightAnchor.constraint(equalToConstant: 260)
        ])
        // UIView won't receive touch events for touches outside the frame of its superview
        // So even if you can position subviews outside of the superview's frame, the subview will still not receive touch events
        // If tamic is set to false, the frame of the view will be overridden once the constraints are activated 
        for i in 1...8 {
            let shipNumberBtn = UIButton(type: .custom)
            shipNumberBtn.setImage(UIImage(systemName: "\(i).square"), for: .normal)
            shipNumberBtn.setImage(UIImage(systemName: "\(i).square.fill"), for: .selected)
            shipNumberBtn.addTarget(self, action: #selector(referenceShipSelectionDidChange(_:)), for: .touchUpInside)
            let symbolCfg = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
            shipNumberBtn.setPreferredSymbolConfiguration(symbolCfg, forImageIn: .normal)
            shipNumberBtn.setPreferredSymbolConfiguration(symbolCfg, forImageIn: .selected)
            shipNumberBtn.tag = (i-1)
            shipNumberBtn.translatesAutoresizingMaskIntoConstraints = false
            referenceShipSelectionMenu.addArrangedSubview(shipNumberBtn)
        }
        // Disabling all the other buttons 2-7 at the start
        for i in 1...7 {
            let btn = referenceShipSelectionMenu.arrangedSubviews[i] as? UIButton
            btn?.isEnabled = false
        }
        // set reference ship to be first ship by default
        self.currentReferenceShip = referenceShipSelectionMenu.arrangedSubviews[0] as? UIButton
        self.currentReferenceShip.isSelected = true
    }
    
    func connectActionMethodsAndDelegates() {
        let keyboardToolbar = KeyboardToolbar(target: self, action: #selector(doneButtonTapped))
        
        // formation view
        commandMenu.segmentedControl.addTarget(self, action: #selector(commandMenuValueDidChange(_:)), for: .valueChanged)
        commandMenu.formationView.trueBrgTextField.delegate = self
        commandMenu.formationView.relBrgTextField.delegate = self
        commandMenu.formationView.trueBrgTextField.addTarget(self, action: #selector(formationTextFieldsDidChange(_:)), for: .editingChanged)
        commandMenu.formationView.relBrgTextField.addTarget(self, action: #selector(formationTextFieldsDidChange(_:)), for: .editingChanged)
        commandMenu.formationView.relBrgTextField.inputAccessoryView = keyboardToolbar
        commandMenu.formationView.trueBrgTextField.inputAccessoryView = keyboardToolbar
        commandMenu.formationView.resetButton.addTarget(self, action: #selector(resetCommandMenu), for: .touchUpInside)
        commandMenu.formationView.executeButton.addTarget(self, action: #selector(executeFormation), for: .touchUpInside)
        
        // corpen view
        commandMenu.corpenView.trueBrgTextField.delegate = self
        commandMenu.corpenView.trueBrgTextField.inputAccessoryView = keyboardToolbar
        commandMenu.corpenView.resetButton.addTarget(self, action: #selector(resetCommandMenu), for: .touchUpInside)
        commandMenu.corpenView.executeButton.addTarget(self, action: #selector(executeCorpen), for: .touchUpInside)
        
        // turn view
        commandMenu.turnView.trueBrgTextField.delegate = self
        commandMenu.turnView.relBrgTextField.delegate = self
        commandMenu.turnView.trueBrgTextField.addTarget(self, action: #selector(turnTextFieldsDidChange(_:)), for: .editingChanged)
        commandMenu.turnView.relBrgTextField.addTarget(self, action: #selector(turnTextFieldsDidChange(_:)), for: .editingChanged)
        commandMenu.turnView.trueBrgTextField.inputAccessoryView = keyboardToolbar
        commandMenu.turnView.relBrgTextField.inputAccessoryView = keyboardToolbar
        commandMenu.turnView.resetButton.addTarget(self, action: #selector(resetCommandMenu), for: .touchUpInside)
        commandMenu.turnView.executeButton.addTarget(self, action: #selector(executeTurn), for: .touchUpInside)
    }
}

