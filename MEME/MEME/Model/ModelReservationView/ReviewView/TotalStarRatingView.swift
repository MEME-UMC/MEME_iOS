//
//  TotalStarRatingView.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit
import SnapKit

struct StarRatingDistribution {
    var fiveStars: Int
    var fourStars: Int
    var threeStars: Int
    var twoStars: Int
    var oneStar: Int
}

class TotalStarRatingView: UIView {
    // 별점 별 프로그레스 바
    private let fiveStarProgressView = UIProgressView(progressViewStyle: .default)
    private let fourStarProgressView = UIProgressView(progressViewStyle: .default)
    private let threeStarProgressView = UIProgressView(progressViewStyle: .default)
    private let twoStarProgressView = UIProgressView(progressViewStyle: .default)
    private let oneStarProgressView = UIProgressView(progressViewStyle: .default)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // 프로그레스 바들의 기본 설정을 여기에서 할 수 있습니다.
        [fiveStarProgressView, fourStarProgressView, threeStarProgressView, twoStarProgressView, oneStarProgressView].forEach {
            $0.trackTintColor = UIColor.lightGray
            $0.progressTintColor = UIColor.red
            addSubview($0)
        }
    }

    func update(with distribution: StarRatingDistribution) {
        let totalRatings = distribution.fiveStars + distribution.fourStars + distribution.threeStars + distribution.twoStars + distribution.oneStar
        guard totalRatings > 0 else { return }

        fiveStarProgressView.progress = Float(distribution.fiveStars) / Float(totalRatings)
        fourStarProgressView.progress = Float(distribution.fourStars) / Float(totalRatings)
        threeStarProgressView.progress = Float(distribution.threeStars) / Float(totalRatings)
        twoStarProgressView.progress = Float(distribution.twoStars) / Float(totalRatings)
        oneStarProgressView.progress = Float(distribution.oneStar) / Float(totalRatings)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let barHeight: CGFloat = 4
        let spacing: CGFloat = 8
        let width = bounds.width

        var yOffset: CGFloat = 0
        for bar in [fiveStarProgressView, fourStarProgressView, threeStarProgressView, twoStarProgressView, oneStarProgressView] {
            bar.frame = CGRect(x: 0, y: yOffset, width: width, height: barHeight)
            yOffset += barHeight + spacing
        }
    }
}