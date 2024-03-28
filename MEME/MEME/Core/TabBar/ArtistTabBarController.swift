//
//  ArtistTabBarController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

final class ArtistTabBarController: UITabBarController {
    
    private var tabs: [TabBarItemType: UIViewController] = [:]
//    private var tabs: [TabBarItemType: UINavigationController] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItems()
        setUI()
    }

    private func setTabBarItems() {
        tabs = [
            TabBarItemType.artistHome: ArtistHomeViewController(),
            TabBarItemType.artistReservation: ManagementReservationsViewController(),
            TabBarItemType.artistMypage: ArtistMyPageViewController()
        ]

        tabs.forEach { tabType, navigationController in
            navigationController.tabBarItem = tabType.setTabBarItem()
        }
        let sortedKeys = tabs.sorted { $0.key.rawValue < $1.key.rawValue }
        
        let tabViewControllers = sortedKeys.map { tabs[$0.key] ?? UIViewController() }
        setViewControllers(tabViewControllers, animated: false)
    }
    
    private func setUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .mainBold
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
