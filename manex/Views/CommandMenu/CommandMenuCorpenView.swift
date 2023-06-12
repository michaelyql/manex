//
//  CommandMenuCorpenView.swift
//  manex
//
//  Created by michaelyangqianlong on 28/5/23.
//

import UIKit

class CommandMenuCorpenView: UIStackView {
    
    weak var deltaSwitch: UISwitch!
    weak var trueBrgTextField: UITextField!
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
        row1Label.text = "CORPEN D"
        row1Label.textColor = .black
        let cRow1Switch = UISwitch(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        self.deltaSwitch = cRow1Switch
        cRow1Switch.preferredStyle = .sliding
        row1.addArrangedSubview(row1Label)
        row1.addArrangedSubview(cRow1Switch)
        
        let row2 = UIStackView()
        self.addArrangedSubview(row2)
        row2.axis = .horizontal
        row2.distribution = .equalSpacing
        row2.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        row2.isLayoutMarginsRelativeArrangement = true
        let row2Label = UILabel()
        row2Label.text = "TRUE BRG"
        row2Label.textColor = .black
        let cRow2TextField = UITextField()
        self.trueBrgTextField = cRow2TextField
        cRow2TextField.clearsOnBeginEditing = true
        cRow2TextField.backgroundColor = .white
        cRow2TextField.translatesAutoresizingMaskIntoConstraints = false
        cRow2TextField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cRow2TextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cRow2TextField.placeholder = "000"
        cRow2TextField.textAlignment = .center
        cRow2TextField.borderStyle = .roundedRect
        cRow2TextField.keyboardType = .numberPad
        cRow2TextField.textColor = .black
        row2.addArrangedSubview(row2Label)
        row2.addArrangedSubview(cRow2TextField)
        
        let corpenSpacer = UIView()
        corpenSpacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.addArrangedSubview(corpenSpacer)
        
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
    
    func getUserInputs() -> CorpenInputs {
        var trueBrg: CGFloat?
        
        if let trueBrgText = trueBrgTextField.text, let temp = Double(trueBrgText) {
            trueBrg = CGFloat(temp)
        }
        
        return CorpenInputs(isDeltaSwitchOn: deltaSwitch.isOn, trueBrg: trueBrg)
    }
}

struct CorpenInputs {
    let isDeltaSwitchOn: Bool
    let trueBrg: CGFloat?
}
