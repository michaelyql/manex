//
//  CommandMenuTurnView.swift
//  manex
//
//  Created by michaelyangqianlong on 28/5/23.
//

import UIKit

class CommandMenuTurnView: UIStackView {
    
    weak var trueBrgTextField: UITextField!
    weak var relDirSegmentControl: UISegmentedControl!
    weak var relBrgTextField: UITextField!
    weak var resetButton: ResetButton!
    weak var executeButton: ExecuteButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .vertical
        self.distribution = .fill
        
        let row1 = UIStackView()
        self.addArrangedSubview(row1)
        row1.axis = .horizontal
        row1.distribution = .equalSpacing
        row1.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row1.isLayoutMarginsRelativeArrangement = true
        let row1Label = UILabel()
        row1Label.text = "TRUE BRG"
        row1Label.textColor = .black
        let row1TextField = UITextField()
        self.trueBrgTextField = row1TextField
        row1TextField.clearsOnBeginEditing = true
        row1TextField.backgroundColor = .white
        row1TextField.translatesAutoresizingMaskIntoConstraints = false
        row1TextField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        row1TextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        row1TextField.placeholder = "000"
        row1TextField.textAlignment = .center
        row1TextField.borderStyle = .roundedRect
        row1TextField.keyboardType = .numberPad
        row1TextField.textColor = .black
        row1TextField.tag = 0
        row1.addArrangedSubview(row1Label)
        row1.addArrangedSubview(row1TextField)
        
        let row2 = UIStackView()
        self.addArrangedSubview(row2)
        row2.axis = .horizontal
        row2.distribution = .equalSpacing
        row2.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row2.isLayoutMarginsRelativeArrangement = true
        let row2SegmentControl = UISegmentedControl(items: ["PT", "SB"])
        self.relDirSegmentControl = row2SegmentControl
        row2SegmentControl.selectedSegmentTintColor = .systemBlue
        row2SegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        row2SegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        row2SegmentControl.translatesAutoresizingMaskIntoConstraints = false
        row2SegmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let row2TextField = UITextField()
        self.relBrgTextField = row2TextField
        row2TextField.clearsOnBeginEditing = true
        row2TextField.backgroundColor = .white
        row2TextField.translatesAutoresizingMaskIntoConstraints = false
        row2TextField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        row2TextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        row2TextField.placeholder = "00"
        row2TextField.textAlignment = .center
        row2TextField.borderStyle = .roundedRect
        row2TextField.keyboardType = .numberPad
        row2TextField.textColor = .black
        row2TextField.tag = 1
        row2.addArrangedSubview(row2SegmentControl)
        row2.addArrangedSubview(row2TextField)
        
        let turnSpacer = UIView()
        turnSpacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.addArrangedSubview(turnSpacer)
        
        let lastRow = UIStackView()
        self.addArrangedSubview(lastRow)
        lastRow.axis = .horizontal
        lastRow.distribution = .equalSpacing
        lastRow.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        lastRow.isLayoutMarginsRelativeArrangement = true
        let resetBtn = ResetButton()
        let executeBtn = ExecuteButton()
        self.resetButton = resetBtn
        self.executeButton = executeBtn
        lastRow.addArrangedSubview(resetBtn)
        lastRow.addArrangedSubview(executeBtn)
    }
    
    required init(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func getUserInputs() -> TurnInputs {
        var trueBrg: CGFloat?
        var relBrg: CGFloat?
        
        if let trueBrgText = trueBrgTextField.text, let temp = Double(trueBrgText) {
            trueBrg = CGFloat(temp)
        } else if let relBrgText = relBrgTextField.text, let temp = Double(relBrgText) {
            relBrg = CGFloat(temp)
        }
        
        return TurnInputs(trueBrg: trueBrg, relBrg: relBrg, relDir: relDirSegmentControl.selectedSegmentIndex)
    }
}
