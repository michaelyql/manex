//
//  HomeViewController.swift
//  manexapp
//
//  Created by michaelyangqianlong on 22/4/23.
//

import Foundation
import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController {
    
    var delegate: HomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(didTapMenuButton))
        
        view.layer.borderWidth = 1
        view.layer.borderColor = .init(red: 0, green: 45/360, blue: 225/360, alpha: 1.0)
    }
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
 
}
