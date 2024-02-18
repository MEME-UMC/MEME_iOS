//
//  TabBarItemType.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case modelHome
    case modelReservation
    case modelMypage //추후 아티스트 마이페이지와 같다면 수정될 수 있음
    case artistHome
    case artistReservation
    case artistMypage
}

extension TabBarItemType {
    // TODO: - 이미지(selected, unselected) 추가
    
    var title: String {
        switch self {
        case .artistHome, .modelHome:
            return "홈"
        case .artistReservation, .modelReservation:
            return "예약"
        case .artistMypage, .modelMypage:
            return "MY"
        }
    }
    
    var unselectedImage: UIImage? {
        switch self {
        case .modelHome, .artistHome:
            return UIImage(named: "Home")
        case .modelReservation, .artistReservation:
            return UIImage(named: "Reservation")
        case .modelMypage, .artistMypage:
            return UIImage(named: "My")
        }
    }
        
    var selectedImage: UIImage? {
        switch self {
        case .modelHome, .artistHome:
            return UIImage(named: "selectedHome")
        case .modelReservation, .artistReservation:
            return UIImage(named: "selectedReservation")
        case .modelMypage, .artistMypage:
            return UIImage(named: "selectedMy")
        }
    }
    
    func setTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: title,
            image: unselectedImage?.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal)
        )
    }
}
