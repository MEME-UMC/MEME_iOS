//
//  ModelReservationShopLocationView.swift
//  MEME
//
//  Created by 정민지 on 2/5/24.
//

import UIKit
import SnapKit

class ModelReservationShopLocationView: UIView {
    // MARK: - Properties
    private var checkShopLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업 받을 장소를 확인해주세요."
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var shopLocationBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.mainBold.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    private var shopLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업 샵 이름"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        label.numberOfLines = 0
        
        return label
    }()

    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    private func configureSubviews() {
        backgroundColor = .white
        addSubview(checkShopLocationLabel)
        addSubview(shopLocationBgView)
        shopLocationBgView.addSubview(shopLocationLabel)
    }
    
    // MARK: - makeConstraints
    private func makeConstraints() {
        checkShopLocationLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        shopLocationBgView.snp.makeConstraints { make in
            make.top.equalTo(checkShopLocationLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        shopLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(shopLocationBgView.snp.top).offset(10)
            make.leading.equalTo(shopLocationBgView.snp.leading).offset(7)
            make.trailing.equalTo(shopLocationBgView.snp.trailing).offset(-7)
            make.bottom.equalTo(shopLocationBgView.snp.bottom).offset(-10)
        }
    
    }
    // MARK: -Method
    func setCheckShopLocationLabelFont(_ font: UIFont) {
        checkShopLocationLabel.font = font
    }
}

extension ModelReservationShopLocationView {
    func configureModelReservationShopLocationView(with data: MakeupLocationData) {
        shopLocationLabel.text = data.shopLocation
    }
}
