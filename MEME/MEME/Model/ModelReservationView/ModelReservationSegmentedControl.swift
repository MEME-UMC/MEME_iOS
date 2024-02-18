//
//  ModelReservationSegmentedControl.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit

struct UnderbarInfo {
  var height: CGFloat
  var barColor: UIColor
  var backgroundColor: UIColor
}

final class ModelReservationSegmentedControl: UISegmentedControl {
    
    // MARK: - Properties
    private lazy var underbar: UIView = makeUnderbar()
    
    private lazy var underbarWidth: CGFloat? = bounds.size.width / CGFloat(numberOfSegments)
    
    private var underbarInfo: UnderbarInfo
    
    private var isFirstSettingDone = false
    
    private lazy var reviewNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainBold
        // label 내용 api에서 받아온 숫자로 수정 필요
        label.text = "3"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(to: .regular, size: 14)

        return label
      }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, underbarInfo info: UnderbarInfo) {
        self.underbarInfo = info
        super.init(frame: frame)
        configureUI()
    }
    
    init(items: [Any]?, underbarInfo info: UnderbarInfo) {
        self.underbarInfo = info
        super.init(items: items)
        configureUI()
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isFirstSettingDone {
            isFirstSettingDone.toggle()
            setUnderbarMovableBackgroundLayer()
            setReviewNumLabelInSegmentedViews()
            layer.cornerRadius = 0
            layer.masksToBounds = false
        }
        let underBarLeadingSpacing = CGFloat(selectedSegmentIndex) * (underbarWidth ?? 50)
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseOut, animations: {
            self.underbar.transform = .init(translationX: underBarLeadingSpacing, y: 0)
        })
    }
    func setReviewCount(_ count: Int) {
        reviewNumLabel.text = "\(count)"
    }
}


// MARK: - Private Helpers
private extension ModelReservationSegmentedControl {
    func configureUI() {
        removeBorders()
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        setTitleTextAttributes(textAttributes, for: .normal)
        setTitleTextAttributes(textAttributes, for: .selected)
        selectedSegmentTintColor = .clear
    }
    
    func setUnderbarMovableBackgroundLayer() {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = .init(
            x: 0,
            y: bounds.height - underbarInfo.height,
            width: bounds.width,
            height: underbarInfo.height)
        backgroundLayer.backgroundColor = underbarInfo.backgroundColor.cgColor
        backgroundLayer.cornerRadius = underbarInfo.height/2
        layer.addSublayer(backgroundLayer)
    }
    
    func setReviewNumLabelInSegmentedViews() {
        let titles = (0..<numberOfSegments).map {
            titleForSegment(at: $0)
        }
        
        let segmentedTitleLabels = subviews
            .compactMap { subview in
                subview.subviews.compactMap { $0 as? UILabel }
            }
            .flatMap { $0 }
            .sorted {
                guard
                    let idx1 = titles.firstIndex(of: $0.text ?? ""),
                    let idx2 = titles.firstIndex(of: $1.text ?? "")
                else { return false }
                return idx1 < idx2
            }
        
        if let secondSegmentLabel = segmentedTitleLabels.first(where: { $0.text == titles[1] }) {
            secondSegmentLabel.addSubview(reviewNumLabel)
            reviewNumLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                reviewNumLabel.centerYAnchor.constraint(equalTo: secondSegmentLabel.centerYAnchor),
                reviewNumLabel.leadingAnchor.constraint(equalTo: secondSegmentLabel.trailingAnchor, constant: 5)
            ])
        }
    }


    
    func makeUnderbar() -> UIView {
        return {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = underbarInfo.barColor
            $0.layer.cornerRadius = underbarInfo.height/2
            addSubview($0)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                $0.widthAnchor.constraint(equalToConstant: underbarWidth ?? 50),
                $0.heightAnchor.constraint(equalToConstant: underbarInfo.height)])
            return $0
        }(UIView(frame: .zero))
    }
    
    func removeBorders() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}
