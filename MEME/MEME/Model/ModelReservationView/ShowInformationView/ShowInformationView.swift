//
//  ShowInformationView.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit
import SnapKit

class ShowInformationView: UIView {
    // MARK: - Properties
    private var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요, 김차차입니다. 첫 세팅 기준 10만원이고,\n컨셉 변경될 경우 금액이 추가됩니다. 감사합니다.\ninsta@kimchacha"
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
    func configure(infoText: String) {
        informationLabel.text = infoText
    }
    
    // MARK: - configureSubviews
    private func configureSubviews() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(informationLabel)
    }
    
    // MARK: - makeConstraints
    private func makeConstraints() {
        informationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }

}
