//
//  BusinessLocationCollectionViewCell.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit
import SnapKit

final class BusinessLocationCollectionViewCell: UICollectionViewCell {
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(to: .semiBold, size: 12)
        label.textColor = .gray500
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setLayout()
    }
    
    private func setUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.gray300.cgColor
    }
    
    private func setLayout() {
        contentView.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(
        location: String
    ) {
        locationLabel.text = location
    }
    
    func setColor(isSelected: Bool) {
        let layerColor: UIColor = isSelected ? .mainBold : .gray300
        let textColor: UIColor = isSelected ? .mainBold : .gray500
        
        contentView.layer.borderColor = layerColor.cgColor
        locationLabel.textColor = textColor
    }
}
