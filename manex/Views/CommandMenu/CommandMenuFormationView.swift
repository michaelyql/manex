//
//  CommandMenuFormationView.swift
//  manexapp
//
//  Created by michaelyangqianlong on 27/5/23.
//

import UIKit

class CommandMenuFormationView: UIStackView {
    
    weak var golfSwitch: UISwitch!
    weak var trueBrgTextField: UITextField!
    weak var relDirSegmentControl: UISegmentedControl!
    weak var relBrgTextField: UITextField!
    weak var divSegmentControl: UISegmentedControl!
    weak var resetButton: ResetButton!
    weak var executeButton: ExecuteButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 1.0
        self.clipsToBounds = false
        self.frame = CGRect(x: 0, y: 0, width: 350, height: 260)
        self.axis = .vertical
        self.distribution = .fill
        
        setupRows()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRows() {
        // first row
        let row1 = UIStackView()
        self.addArrangedSubview(row1)
        row1.axis = .horizontal
        row1.distribution = .equalSpacing
        row1.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row1.isLayoutMarginsRelativeArrangement = true
        let row1Label = UILabel()
        row1Label.text = "FORM G"
        row1Label.textColor = .systemBlue
        let row1Switch = UISwitch(frame: CGRect(x: 0, y: 0, width: 90, height: 20))
        self.golfSwitch = row1Switch
        row1Switch.preferredStyle = .sliding
        row1Switch.onTintColor = .systemBlue
        row1.addArrangedSubview(row1Label)
        row1.addArrangedSubview(row1Switch)
        
        // second row
        let row2 = UIStackView()
        self.addArrangedSubview(row2)
        row2.axis = .horizontal
        row2.distribution = .equalSpacing
        row2.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row2.isLayoutMarginsRelativeArrangement = true
        let row2Label = UILabel()
        row2Label.text = "TRUE BRG"
        row2Label.textColor = .systemBlue
        let row2TextField = UITextField()
        self.trueBrgTextField = row2TextField
        row2TextField.clearsOnBeginEditing = true
        row2TextField.backgroundColor = .white
        row2TextField.translatesAutoresizingMaskIntoConstraints = false
        row2TextField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        row2TextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        row2TextField.placeholder = "000"
        row2TextField.textAlignment = .center
        row2TextField.borderStyle = .roundedRect
        row2TextField.keyboardType = .numberPad
        row2TextField.textColor = .black
        row2TextField.tag = 0
        row2.addArrangedSubview(row2Label)
        row2.addArrangedSubview(row2TextField)
        
        // third row
        let row3 = UIStackView()
        self.addArrangedSubview(row3)
        row3.axis = .horizontal
        row3.distribution = .equalSpacing
        row3.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row3.isLayoutMarginsRelativeArrangement = true
        let row3SegmentControl = UISegmentedControl(items: ["PT", "SB"])
        self.relDirSegmentControl = row3SegmentControl
        row3SegmentControl.selectedSegmentTintColor = .systemBlue
        row3SegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        row3SegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        row3SegmentControl.translatesAutoresizingMaskIntoConstraints = false
        row3SegmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let row3TextField = UITextField()
        self.relBrgTextField = row3TextField
        row3TextField.clearsOnBeginEditing = true
        row3TextField.backgroundColor = .white
        row3TextField.translatesAutoresizingMaskIntoConstraints = false
        row3TextField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        row3TextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        row3TextField.placeholder = "00"
        row3TextField.textAlignment = .center
        row3TextField.borderStyle = .roundedRect
        row3TextField.keyboardType = .numberPad
        row3TextField.textColor = .black
        row3TextField.tag = 1
        row3.addArrangedSubview(row3SegmentControl)
        row3.addArrangedSubview(row3TextField)
        
        // fourth row
        let row4 = UIStackView()
        self.addArrangedSubview(row4)
        row4.axis = .horizontal
        row4.distribution = .equalSpacing
        row4.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row4.isLayoutMarginsRelativeArrangement = true
        let row4SegmentControl = UISegmentedControl(items: ["DIV", "SUBDIV"])
        self.divSegmentControl = row4SegmentControl
        row4SegmentControl.selectedSegmentTintColor = .systemBlue
        row4SegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        row4SegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        row4SegmentControl.translatesAutoresizingMaskIntoConstraints = false
        row4SegmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        row4.addArrangedSubview(row4SegmentControl)
        
        // fifth row
        let row5 = UIStackView()
        self.addArrangedSubview(row5)
        row5.axis = .horizontal
        row5.distribution = .equalSpacing
        row5.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row5.isLayoutMarginsRelativeArrangement = true
        let resetBtn = ResetButton()
        let executeBtn = ExecuteButton()
        self.resetButton = resetBtn
        self.executeButton = executeBtn
        row5.addArrangedSubview(resetBtn)
        row5.addArrangedSubview(executeBtn)
    }
    
    func updateTextFields(activeTextFieldTag: Int) {
        switch activeTextFieldTag {
        case 0:
            self.relDirSegmentControl.selectedSegmentIndex = -1
            self.relDirSegmentControl.isEnabled = false
            self.relBrgTextField.text = nil
        case 1:
            self.trueBrgTextField.text = nil
            self.relDirSegmentControl.isEnabled = true
        default:
            break
        }
    }
    
    func getUserInputs() -> FormationInputs {
        var trueBrg: CGFloat?
        var relBrg: CGFloat?
        
        if let trueBrgText = trueBrgTextField.text, let temp = Double(trueBrgText) {
            trueBrg = CGFloat(temp)
        } else if let relBrgText = relBrgTextField.text, let temp = Double(relBrgText) {
            relBrg = CGFloat(temp)
        }
        
        return FormationInputs(isGolfSwitchOn: golfSwitch.isOn,
                               trueBrg: trueBrg,
                               relBrg: relBrg,
                               relDir: relDirSegmentControl.selectedSegmentIndex,
                               divSeparation: divSegmentControl.selectedSegmentIndex)
    }
}

struct FormationInputs {
    let isGolfSwitchOn: Bool
    let trueBrg: CGFloat?
    let relBrg: CGFloat?
    let relDir: Int
    let divSeparation: Int
}

