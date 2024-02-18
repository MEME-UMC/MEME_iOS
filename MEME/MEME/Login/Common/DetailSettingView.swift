//
//  DetailSettingView.swift
//  MEME
//
//  Created by 이동현 on 1/17/24.
//

import UIKit

protocol DetailSettingButtonTapped: AnyObject {
    func detailSettingButtonTapped(
        title: String,
        type: DetailSettingViewType
    )
}

enum DetailSettingViewType {
    case gender
    case skinType
    case personalColor
}

final class DetailSettingView: UIView {
    
    @IBOutlet private weak var imageVIew: UIImageView!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var label: UILabel!
    weak var delegate: DetailSettingButtonTapped?
    private var type: DetailSettingViewType = .gender
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        loadNib()
        backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderColor = UIColor.gray400.cgColor
    }
    
    func configure(
        title: String,
        tag: Int,
        type: DetailSettingViewType
    ) {
        label.text = title
        label.font = .pretendard(to: .regular, size: 14)
        button.tag = tag
        self.type = type
    }
    
    @IBAction private func buttonTapped(_ sender: Any) {
        button.isSelected.toggle()
        if button.isSelected {
            imageVIew.image = .detailSelected
            layer.borderColor = UIColor.clear.cgColor
        } else {
            deselect(title: "")
        }
        
        delegate?.detailSettingButtonTapped(
            title: label.text ?? "",
            type: type
        )
    }
    
    func deselect(title: String) {
        guard let text = label.text else { return }
        if text != title {
            layer.borderColor = UIColor.gray400.cgColor
            button.isSelected = false
            imageVIew.image = nil
        }
    }
}
