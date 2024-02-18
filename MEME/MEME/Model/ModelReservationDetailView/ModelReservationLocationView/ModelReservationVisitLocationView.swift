//
//  ModelReservationVisitLocationView.swift
//  MEME
//
//  Created by 정민지 on 2/5/24.
//

import UIKit
import SnapKit

protocol ModelReservationVisitLocationViewDelegate: AnyObject {
    func didEnterVisitLocation(_ location: String)
}

class ModelReservationVisitLocationView: UIView, UITextFieldDelegate {
    // MARK: - Properties
    weak var delegate: ModelReservationVisitLocationViewDelegate?
    private var savedTextFieldValue: String?
    
    private var inputVisitLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업 받을 장소를 입력해주세요."
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var artistAvailabilityLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트 방문 가능 지역: 서울 동작구, 영등포구"
        label.textColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        label.font = .pretendard(to: .regular, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    var visitLocationTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = " 정확한 위치를 입력해주세요."
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray400])
        
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.mainBold.cgColor
        textField.layer.borderWidth = 1
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    
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
        addSubview(inputVisitLocationLabel)
        addSubview(artistAvailabilityLocationLabel)
        visitLocationTextField.delegate = self
        addSubview(visitLocationTextField)
    }
    
    // MARK: - makeConstraints
    private func makeConstraints() {
        inputVisitLocationLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        artistAvailabilityLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(inputVisitLocationLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        visitLocationTextField.snp.makeConstraints { make in
            make.top.equalTo(artistAvailabilityLocationLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - Method
    func setInputVisitLocationLabelFont(_ font: UIFont) {
            inputVisitLocationLabel.font = font
    }
    func getSavedTextFieldValue() -> String? {
        return savedTextFieldValue
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == visitLocationTextField {
            savedTextFieldValue = textField.text
        }
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == visitLocationTextField {
            savedTextFieldValue = textField.text
            delegate?.didEnterVisitLocation(textField.text ?? "")
        }
    }
    
}

extension ModelReservationVisitLocationView {
    func configureModelReservationVisitLocationView(with data: MakeupLocationData) {
        artistAvailabilityLocationLabel.text = "아티스트 방문 가능 지역: \(data.region)"
    }
}
