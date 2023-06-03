//
//  MenuViewController.swift
//  manexapp
//
//  Created by michaelyangqianlong on 22/4/23.
//

import Foundation
import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: MenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case manex = "Manex"
        case settings = "Settings"
        
        var imageName: String {
            switch self {
                
            case .home:
                return "house"
            case .manex:
                return "safari"
            case .settings:
                return "gearshape.fill"
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.insetsContentViewsToSafeArea = false
        return table
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        // Menu VC's view is the whole screen
        // But table view is constrained within phone safe area
        // Menu VC's view is stacked on top of Container VC's view
        
        // Colour of table view needs to be set in viewDidLoad(), otherwise it will not show
        tableView.backgroundColor = .white
        
        tableView.sectionHeaderTopPadding = 0
        print("")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MenuOptions.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.section].imageName)
        cell.imageView?.tintColor = UIColor(red: 0/360, green: 45/360, blue: 225/360, alpha: 1.0)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.section].rawValue
        cell.textLabel?.textColor = UIColor(red: 0/360, green: 45/360, blue: 225/360, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 16)

        
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.section]
        delegate?.didSelect(menuItem: item)
    }
}
