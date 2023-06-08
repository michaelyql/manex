//
//  FormationSelectorView.swift
//  manex
//
//  Created by michaelyangqianlong on 28/5/23.
//

import UIKit

class FormationScrollView: UIStackView {
    
    weak var buttonStack: UIStackView!
    weak var optionsButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.alignment = .fill
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.alpha = 0.0
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(scrollView)
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalToConstant: 300),
        ])
        
        let buttonStack = UIStackView()
        self.buttonStack = buttonStack
        scrollView.addSubview(buttonStack)
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        buttonStack.spacing = 10
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            buttonStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            buttonStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        for i in 1...12 {
            let button = UIButton()
            button.setImage(UIImage(systemName: String(i) + ".square"), for: .normal)
            let largeConfig = UIImage.SymbolConfiguration(scale: .large)
            button.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
            button.tag = i
            buttonStack.addArrangedSubview(button)
        }
        
        // 'More Options' button (right col)
        let largeSymbolConfig = UIImage.SymbolConfiguration(scale: .large)
        let optionsButton = UIButton()
        optionsButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        self.optionsButton = optionsButton
        optionsButton.setPreferredSymbolConfiguration(largeSymbolConfig, forImageIn: .normal)
        optionsButton.backgroundColor = .white
        self.addArrangedSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        optionsButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            optionsButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("not implemented")
    }
}

