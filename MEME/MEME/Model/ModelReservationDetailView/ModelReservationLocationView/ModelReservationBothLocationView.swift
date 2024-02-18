//
//  ModelReservationBothLocationView.swift
//  MEME
//
//  Created by 정민지 on 2/5/24.
//

import UIKit
import SnapKit

protocol ModelReservationBothLocationViewDelegate: AnyObject {
    func didSelectLocationType(_ LocationType: String)
    func didSelectShopLocation(_ location: String)
    func didSelectVisitLocation(_ location: String)
}

class  ModelReservationBothLocationView: UIView {
    // MARK: - Properties
    weak var delegate: ModelReservationBothLocationViewDelegate?
    private var makeupLocationData: MakeupLocationData?
        
    private let selectLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업 받을 장소를 선택해주세요."
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var selectOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    private let goShopButton: UIButton = {
        let button = UIButton()
        button.setTitle("샵으로 갈게요", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.gray300.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        
        return button
    }()
    private let comeVisitButton: UIButton = {
        let button = UIButton()
        button.setTitle("직접 방문해주세요.", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.gray300.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        
        return button
    }()
    private let selectOptionResultStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        
        return stack
    }()
    
    private var visitView: ModelReservationVisitLocationView!
    private var shopView: ModelReservationShopLocationView!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        makeConstraints()
        setupDismissKeyboardOnTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
        makeConstraints()
        setupDismissKeyboardOnTapGesture()
    }
    
    // MARK: - configureSubviews
    private func configureSubviews() {
        backgroundColor = .white
        addSubview(selectLocationLabel)
        addSubview(selectOptionsStackView)
        selectOptionsStackView.addArrangedSubview(goShopButton)
        selectOptionsStackView.addArrangedSubview(comeVisitButton)
        addSubview(selectOptionResultStackView)
    }
    
    // MARK: - makeConstraints
    private func makeConstraints() {
        selectLocationLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        selectOptionsStackView.snp.makeConstraints { make in
            make.top.equalTo(selectLocationLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        selectOptionResultStackView.snp.makeConstraints { make in
            make.top.equalTo(selectOptionsStackView.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    //MARK: - Button Action
    @objc private func buttonDidTap(_ sender: UIButton) {
        resetButtons()
        
        sender.backgroundColor = .mainBold
        sender.layer.borderWidth = 0
        sender.setTitleColor(.white, for: .normal)
        
        if sender == goShopButton {
            delegate?.didSelectLocationType("SHOP")
            delegate?.didSelectShopLocation("샵의 위치")
        } else if sender == comeVisitButton {
            delegate?.didSelectLocationType("VISIT")
            if let visitLocation = visitView.getSavedTextFieldValue() {
                delegate?.didSelectVisitLocation(visitLocation)
            }
        }
        
        if let makeupLocationData = makeupLocationData {
            updateSelectedOptionView(with: makeupLocationData, selectedButton: sender)
        }
    }
    
    private func resetButtons() {
        let buttons = [goShopButton, comeVisitButton]
        for button in buttons {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor.gray300.cgColor
            button.layer.borderWidth = 1
        }
    }
    
    // MARK: - Update SelecteOptionView
    private func updateSelectedOptionView(with data: MakeupLocationData, selectedButton: UIButton) {
        selectOptionResultStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            selectOptionResultStackView.removeArrangedSubview($0)
        }
        
        switch selectedButton {
        case goShopButton:
            if shopView == nil {
                shopView = ModelReservationShopLocationView()
                shopView.setCheckShopLocationLabelFont(.pretendard(to: .regular, size: 14))
                shopView.configureModelReservationShopLocationView(with: data)
            }
            selectOptionResultStackView.addArrangedSubview(shopView)
        case comeVisitButton:
            if visitView == nil {
                visitView = ModelReservationVisitLocationView()
                visitView .configureModelReservationVisitLocationView(with: data)
                visitView.setInputVisitLocationLabelFont(.pretendard(to: .regular, size: 14))
            }
            selectOptionResultStackView.addArrangedSubview(visitView)
        default:
            break
        }
    }
    
    // MARK: - Configuration
        func configureModelReservationBothLocationView(with data: MakeupLocationData) {
            self.makeupLocationData = data
        }
}

