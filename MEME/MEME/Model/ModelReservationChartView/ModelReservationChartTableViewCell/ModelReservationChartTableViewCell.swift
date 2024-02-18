//
//  ModelReservationChartTableViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/20/24.
//

import UIKit
import Alamofire

class ModelReservationChartTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "ModelReservationChartTableViewCell"
    
    @IBOutlet private weak var makeupImgView: UIImageView!
    @IBOutlet private weak var makeupSortView: UIView!
    @IBOutlet private weak var makeupSortLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    
    @IBOutlet private weak var shopView: UIView!
    @IBOutlet private weak var shopLabel: UILabel!
    @IBOutlet private weak var shopLocationLabel: UILabel!
    @IBOutlet private weak var visitView: UIView!
    @IBOutlet private weak var visitLabel: UILabel!
    @IBOutlet private weak var visitLocationLabel: UILabel!
    
    @IBOutlet private weak var makeupNameLabel: UILabel!
    @IBOutlet private weak var makeupPriceLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var reviewLabel: UILabel!
    @IBOutlet private weak var reviewExplainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shopView.backgroundColor = .white
        visitView.backgroundColor = .white
        shopView.layer.borderColor = UIColor.mainLight.cgColor
        visitView.layer.borderColor = UIColor.mainLight.cgColor

    }
    
    func configure(with data: SearchResultData) {
        if let urlString = data.portfolioImgDtoList?.first?.portfolioImgSrc, let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.makeupImgView.image = UIImage(data: data)
                        }
                    } else if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.makeupImgView.image = UIImage(named: "ex_artist_img")
                        }
                    }
                }.resume()
            } else {
                makeupImgView.image = UIImage(named: "ex_artist_img")
            }

        if let categoryEnum = SearchCategory(rawValue: data.category) {
                makeupSortLabel.text = mapSearchCategoryToDisplayName(categoryEnum)
                makeupSortView.backgroundColor = colorForCategory(categoryEnum)
        } else {
            makeupSortLabel.text = "분류 없음"
            makeupSortView.backgroundColor = .gray200
        }
        artistNameLabel.text = data.artistNickName
        makeupNameLabel.text = data.makeupName
        makeupPriceLabel.text = "\(data.price)원"
        reviewLabel.text = "\(data.averageStars)"
        reviewExplainLabel.text = "(\(data.reviewCount))"

        if let shopLocation = data.shopLocation {
            shopLocationLabel.text = shopLocation
        } else {
            shopLocationLabel.text = "위치 정보 없음"
        }
        
        if let regions = data.region {
            let regionsString = regions.joined(separator: ", ")
            visitLocationLabel.text = regionsString
        } else {
            visitLocationLabel.text = "위치 정보 없음"
        }


    }
    
    func mapSearchCategoryToDisplayName(_ category: SearchCategory) -> String {
        switch category {
        case .DAILY:
            return "데일리 메이크업"
        case .ACTOR:
            return "배우 메이크업"
        case .INTERVIEW:
            return "면접 메이크업"
        case .PARTY:
            return "파티/이벤트 메이크업"
        case .WEDDING:
            return "웨딩 메이크업"
        case .PROSTHETIC:
            return "특수 메이크업"
        case .STUDIO:
            return "스튜디오 메이크업"
        case .ETC:
            return "기타(속눈썹, 퍼스널 컬러)"
        }
    }
    func colorForCategory(_ category: SearchCategory) -> UIColor {
        switch category {
        case .DAILY:
            return .mainLight
        case .ACTOR:
            return .subYellowBold
        case .INTERVIEW:
            return .subApricotBold
        case .PARTY:
            return .subSkyBlue
        case .WEDDING:
            return .subPurple
        case .PROSTHETIC:
            return .subYellowLight
        case .STUDIO:
            return .subPink
        case .ETC:
            return .subSkyBlueBold
        }
    }
}
