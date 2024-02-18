//
//  ModelManagementReservationsDateCollectionViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/25/24.
//

import UIKit
import SnapKit

class ModelManagementReservationsDateCollectionViewCell: UICollectionViewCell {
    static let identifier = "ModelManagementReservationsDateCollectionViewCell"
    
    private var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        label.text = "2024. 02. 22 목"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 16)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configure(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd EEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        label.text = dateFormatter.string(from: date)
    }
}
