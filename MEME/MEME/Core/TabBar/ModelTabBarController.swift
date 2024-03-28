//
//  ModelTabBarController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

final class ModelTabBarController: UITabBarController {
    
    private var tabs: [TabBarItemType: UIViewController] = [:]
//    private var tabs: [TabBarItemType: UIViewController] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBarItems()
    }
    
    private func setTabBarItems() {
        tabs = [
            TabBarItemType.modelHome: ModelHomeViewController(),
            TabBarItemType.modelReservation: ModelReservationChartViewController(),
            TabBarItemType.modelMypage: ModelMyPageViewController()
        ]
        
        tabs.forEach { tabType, navigationController in
            navigationController.tabBarItem = tabType.setTabBarItem()
        }
        
        let sortedKeys = tabs.sorted { $0.key.rawValue < $1.key.rawValue }
        
        let tabNavigationControllers = sortedKeys.map { tabs[$0.key] ?? UINavigationController() }
        setViewControllers(tabNavigationControllers, animated: false)
    }
    
    private func setUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .mainBold
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
