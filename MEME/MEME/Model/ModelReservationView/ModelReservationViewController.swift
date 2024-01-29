//
//  ModelReservationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit
// 예시 데이터 구조 -> 이후 삭제 필요
struct ReviewData {
    var profileImage: UIImage?
    var profileName: String
    var starRate: String
    var reviewText: String
    var reviewImages: [UIImage]
}


class ModelReservationViewController: UIViewController {
    // 예시 데이터 배열 -> 이후 삭제 필요
    
    var reviews: [ReviewData] = [
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "메메**",
                   starRate: "5",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: [UIImage(named: "img_exReview1"), UIImage(named: "img_exReview2")].compactMap { $0 }),
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "메메**",
                   starRate: "5",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: [UIImage(named: "img_exReview1"), UIImage(named: "img_exReview2")].compactMap { $0 }),
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "메메**",
                   starRate: "5",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: [UIImage(named: "img_exReview1"), UIImage(named: "img_exReview2")].compactMap { $0 }),
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "차*",
                   starRate: "1",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: []),
        ReviewData(profileImage: UIImage(named: "modelProfile"),
                   profileName: "리*",
                   starRate: "4",
                   reviewText: "후기 작성 칸 후기 작성 칸\n후기후기",
                   reviewImages: [UIImage(named: "img_exReview3")].compactMap { $0 })
    ]
    // MARK: - Properties
    private let navigationBar = NavigationBarView()
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reservation_back")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var backgroundView: UIView = {
        let UIView = UIView()
        UIView.backgroundColor = .white
        UIView.layer.cornerRadius = 17
        
        return UIView
    }()
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "modelProfile")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "김차차"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_like")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    private var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_share")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var makeupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "촬영 메이크업"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 16)
        
        return label
    }()
    private var makeupExplainLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필사진 촬영에 좋아요"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 12)
        
        return label
    }()
    private var makeupPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "100,000"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var topLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    private var qEmploymentStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "샵 재직 여부"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 14)
        
        return label
    }()
    private var aEmploymentStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "🙅🏻프리랜서에요"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var qCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 14)
        
        return label
    }()
    private var aCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "면접 메이크업"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        
        return stack
    }()
    
    private let segmentedControl: ModelReservationSegmentedControl = {
        let underbarInfo = UnderbarInfo(height: 3, barColor: .mainBold, backgroundColor: .gray300)
        let control = ModelReservationSegmentedControl(items: ["정보", "리뷰"], underbarInfo: underbarInfo)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private var informationView = ShowInformationView()
    private var reviewView = ShowReviewView()
    private var reviewTableView: UITableView!
    
    private var underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 6)
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.1).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
    }()
    private let reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("예약하기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(reservationTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.delegate = self
        navigationBar.configure(title: "예약하기")
        
        setupSegmentedControl()

        configureSubviews()
        makeConstraints()
        
        setupGestureRecognizers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath(roundedRect: backgroundView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 17, height: 17))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        backgroundView.layer.mask = maskLayer
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(backgroundImageView)
        contentsView.addSubview(backgroundView)
        contentsView.addSubview(profileImageView)
        contentsView.addSubview(artistNameLabel)
        contentsView.addSubview(likeImageView)
        contentsView.addSubview(shareImageView)
        contentsView.addSubview(makeupNameLabel)
        contentsView.addSubview(makeupExplainLabel)
        contentsView.addSubview(makeupPriceLabel)
        contentsView.addSubview(topLineView)
        contentsView.addSubview(qEmploymentStatusLabel)
        contentsView.addSubview(aEmploymentStatusLabel)
        contentsView.addSubview(qCategoryLabel)
        contentsView.addSubview(aCategoryLabel)
        contentsView.addSubview(underLineView)
        contentsView.addSubview(segmentedControl)
        contentsView.addSubview(mainStackView)
        view.addSubview(underBarView)
        view.addSubview(reservationButton)
    }
    

    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBar.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentsView.snp.top)
            make.leading.equalTo(contentsView.snp.leading)
            make.trailing.equalTo(contentsView.snp.trailing)
            make.height.equalTo(backgroundImageView.snp.width)
        }
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(-31)
            make.leading.equalTo(contentsView.snp.leading)
            make.trailing.equalTo(contentsView.snp.trailing)
            make.bottom.equalTo(contentsView.snp.bottom)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.snp.top).offset(31)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
            make.width.equalTo(52)
            make.height.equalTo(52)
        }
        artistNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo( profileImageView.snp.trailing).offset(16)
        }
        shareImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo( contentsView.snp.trailing).offset(-39)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        likeImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo( shareImageView.snp.leading).offset(-16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        makeupNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        makeupExplainLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(makeupNameLabel.snp.centerY)
            make.leading.equalTo(makeupNameLabel.snp.trailing).offset(22)
        }
        makeupPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(makeupNameLabel.snp.bottom).offset(11)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(makeupPriceLabel.snp.bottom).offset(23)
            make.leading.equalTo(contentsView.snp.leading).offset(14)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-14)
            make.height.equalTo(1)
        }
        qEmploymentStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(20)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        aEmploymentStatusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(qEmploymentStatusLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-44)
        }
        qCategoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qEmploymentStatusLabel.snp.bottom).offset(11)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
        }
        aCategoryLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(qCategoryLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-44)
        }
        underLineView.snp.makeConstraints { (make) in
            make.top.equalTo(qCategoryLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentsView.snp.leading).offset(14)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-14)
            make.height.equalTo(1)
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(underLineView.snp.top)
            make.leading.equalTo(contentsView.snp.leading).offset(25)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(35)
        }
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.equalTo(contentsView.snp.leading).offset(25)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.bottom.equalTo(contentsView.snp.bottom).offset(-100)
        }
        underBarView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(61)
        }
        reservationButton.snp.makeConstraints { (make) in
            make.top.equalTo(underBarView.snp.top).offset(12)
            make.leading.equalTo(underBarView.snp.leading).offset(26)
            make.trailing.equalTo(underBarView.snp.trailing).offset(-26)
            make.height.equalTo(50)
        }
    }
    // MARK: - Action
    private func setupGestureRecognizers() {
        setupTapGestureRecognizer(for: profileImageView, withSelector: #selector(profileImageTapped))
        setupTapGestureRecognizer(for: likeImageView, withSelector: #selector(likeImageTapped))
    }
    private func setupTapGestureRecognizer(for view: UIView, withSelector selector: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    @objc private func reservationTapped() {
        let reservationsVC = ModelReservationDetailViewController()
        navigationController?.pushViewController(reservationsVC, animated: true)
    }
    @objc private func profileImageTapped() {
        let artistProfileVC = ModelViewArtistProfileViewController()
        navigationController?.pushViewController(artistProfileVC, animated: true)
    }
    @objc private func likeImageTapped() {
        if likeImageView.image == UIImage(named: "icon_like") {
            likeImageView.image = UIImage(named: "icon_fillLike")
        } else {
            likeImageView.image = UIImage(named: "icon_like")
        }
    }
    
    // MARK: - Methods
    @objc private func didChangeValue(segment: UISegmentedControl) {
        updateStackView(forSegmentIndex: segment.selectedSegmentIndex)
    }

    private func updateStackView(forSegmentIndex index: Int) {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        switch index {
        case 0:
            mainStackView.addArrangedSubview(informationView)
            reviewTableView?.removeFromSuperview()
            reviewTableView = nil
        case 1:
            mainStackView.addArrangedSubview(reviewView)
            // 리뷰뷰 선택 시 스크롤뷰 아래 리뷰 테이블뷰 생성
            if reviewTableView == nil {
                reviewTableView = UITableView()
                reviewTableView.backgroundColor = .red
                
                reviewTableView.delegate = self
                reviewTableView.dataSource = self
                
                reviewTableView.register(ShowReviewTableViewCell.self, forCellReuseIdentifier: "ShowReviewTableViewCell")
                
                mainStackView.addSubview(reviewTableView)
                                        
                reviewTableView.rowHeight = UITableView.automaticDimension
                reviewTableView.estimatedRowHeight = 44
                
                reviewTableView.snp.makeConstraints { make in
                    make.top.equalTo(reviewView.snp.bottom)
                    make.leading.equalTo(mainStackView.snp.leading)
                    make.trailing.equalTo(mainStackView.snp.trailing)
                    make.bottom.equalTo(mainStackView.snp.bottom)
                }
            }
        default:
            break
        }
    }

    //MARK: -Helpers
    private func setupSegmentedControl() {
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
    }
}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ModelReservationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //cell의 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowReviewTableViewCell", for: indexPath) as? ShowReviewTableViewCell else {
            fatalError("셀 타입 캐스팅 실패...")
        }
        cell.selectionStyle = .none
        let review = reviews[indexPath.row]
        cell.configure(profileImage: review.profileImage,
                       profileName: review.profileName,
                       starRate: review.starRate,
                       reviewImages: review.reviewImages,
                       reviewText: review.reviewText
                       )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
}

//MARK: - UIScrollViewDelegate
extension ModelReservationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           let height = scrollView.frame.size.height
           
           // 스크롤이 맨 아래에 도달했다면, 테이블뷰의 스크롤을 활성화
           if offsetY > contentHeight - height {
               reviewTableView?.isScrollEnabled = true
           } else {
               reviewTableView?.isScrollEnabled = false
           }
       }
}

// MARK: -BackButtonTappedDelegate
extension ModelReservationViewController: BackButtonTappedDelegate  {
    func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
