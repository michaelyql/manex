//
//  CommandMenu.swift
//  manex
//
//  Created by michaelyangqianlong on 28/5/23.
//

import UIKit

class CommandMenu: UIView {
    
    weak var segmentedControl: UISegmentedControl!
    weak var formationView: CommandMenuFormationView!
    weak var corpenView: CommandMenuCorpenView!
    weak var turnView: CommandMenuTurnView!
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        
        self.alpha = 0.0
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        
        let segmentedControl = UISegmentedControl(items: ["FORM", "CORPEN", "TURN"])
        self.segmentedControl = segmentedControl
        self.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.topAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: self.frame.width),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let containerView = UIView()
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: self.frame.width),
            containerView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        let formationView = CommandMenuFormationView()
        let corpenView = CommandMenuCorpenView()
        let turnView = CommandMenuTurnView()
        
        self.formationView = formationView
        self.corpenView = corpenView
        self.turnView = turnView
        
        let containerViewList: [UIView] = [formationView, corpenView, turnView]
        for view in containerViewList {
            containerView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            if view != formationView {
                view.alpha = 0.0
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func bringMenuViewToFront(segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            formationView.alpha = 1.0
            corpenView.alpha = 0.0
            turnView.alpha = 0.0
        case 1:
            formationView.alpha = 0.0
            corpenView.alpha = 1.0
            turnView.alpha = 0.0
        case 2:
            formationView.alpha = 0.0
            corpenView.alpha = 0.0
            turnView.alpha = 1.0
        default:
            break
        }
    }
    
    func clearAllInputs() {
        // form view
        self.formationView.golfSwitch.isOn = false
        self.formationView.trueBrgTextField.text = nil
        self.formationView.relBrgTextField.text = nil
        self.formationView.relDirSegmentControl.selectedSegmentIndex = -1
        self.formationView.divSegmentControl.selectedSegmentIndex = -1
        
        // corpen view
        self.corpenView.deltaSwitch.isOn = false
        self.corpenView.trueBrgTextField.text = nil
        
        // turn view
        self.turnView.trueBrgTextField.text = nil
        self.turnView.relBrgTextField.text = nil
        self.turnView.relDirSegmentControl.selectedSegmentIndex = -1
    }
}
