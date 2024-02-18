//
//  ModelReservationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit

class ModelReservationViewController: UIViewController {
    // MARK: - Properties
    var portfolioID: Int? = 0
    var artistID: Int? = 3
    var makeupName: String?
    var artistName: String?
    
    private var portfolioImageUrls: [String] = []
    private var isFavorite: Bool = false
    
    private let navigationBar = NavigationBarView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    private let contentsView = UIView()
    
    private lazy var backgroundImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        return scrollView
    }()
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .gray500
        pageControl.pageIndicatorTintColor = .white
        
        return pageControl
    }()
    private let defaultImage = UIImage(named: "reservation_back")
   
    
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
    private var currentSegmentIndex = 0
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
        
        fetchPortfolioDetail(userId: 6, portfolioId: portfolioID!)
        fetchImagesFromAPI()
        setupSegmentedControl()

        configureSubviews()
        makeConstraints()
        
        setupGestureRecognizers()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        backgroundImageScrollView.delegate = self
        contentsView.addSubview(backgroundImageScrollView)
        contentsView.addSubview(pageControl)
        contentsView.addSubview(backgroundView)
        contentsView.addSubview(profileImageView)
        contentsView.addSubview(artistNameLabel)
        contentsView.addSubview(likeImageView)
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
        backgroundImageScrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentsView)
            make.height.equalTo(contentsView.snp.width)
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentsView.snp.centerX)
            make.top.equalTo(backgroundImageScrollView.snp.bottom).offset(-70)
        }
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImageScrollView.snp.bottom).offset(-31)
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
            make.width.equalTo(200)
        }
        likeImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo( contentsView.snp.trailing).offset(-39)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        makeupNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
            make.width.equalTo(200)
        }
        makeupExplainLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(makeupNameLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-39)
        }
        makeupPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(makeupNameLabel.snp.bottom).offset(11)
            make.leading.equalTo(contentsView.snp.leading).offset(45)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-45)
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
            make.bottom.equalTo(contentsView.snp.bottom).offset(-50)
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
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let current = sender.currentPage
        backgroundImageScrollView.setContentOffset(CGPoint(x: CGFloat(current) * backgroundImageScrollView.frame.size.width, y: 0), animated: true)
    }
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
        reservationsVC.artistID = artistID
        reservationsVC.portfolioID = portfolioID
        reservationsVC.makeupName = makeupName
        reservationsVC.artistName = artistName
        navigationController?.pushViewController(reservationsVC, animated: true)
    }
    @objc private func profileImageTapped() {
        let artistProfileVC = ModelViewArtistProfileViewController()
        artistProfileVC.artistID = artistID
        navigationController?.pushViewController(artistProfileVC, animated: true)
    }
    private func likeImageDecision() {
        print(isFavorite)
        if isFavorite {
            likeImageView.image = UIImage(named: "icon_fillLike")
        } else {
            likeImageView.image = UIImage(named: "icon_like")
        }
    }
    @objc private func likeImageTapped() {
        if isFavorite {
            if let portfolioID = portfolioID {
                deleteFavoritePortfolio(modelId: 6, portfolioId: portfolioID)
            }
        } else {
            if let portfolioID = portfolioID {
                postFavoritePortfolio(modelId: 6, portfolioId: portfolioID)
            }
        }
    }
    // MARK: - API Actions
    private func fetchImagesFromAPI() {
        if portfolioImageUrls.isEmpty {
            addImageView(image: defaultImage!, index: 0)
        } else {
            for (index, urlString) in portfolioImageUrls.enumerated() {
                guard let url = URL(string: urlString) else { continue }
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let data = data, error == nil, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.addImageView(image: image, index: index)
                        }
                    }
                }.resume()
            }
        }
    }
    
    // MARK: - Methods
    private func addImageView(image: UIImage, index: Int) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        backgroundImageScrollView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(backgroundImageScrollView.snp.width)
            make.top.bottom.equalTo(backgroundImageScrollView)
            make.left.equalTo(backgroundImageScrollView.snp.left).offset(CGFloat(index) * contentsView.frame.size.width)
        }
        
        if index == 0 {
            backgroundImageScrollView.contentSize = CGSize(width: contentsView.frame.width * CGFloat(portfolioImageUrls.count), height: contentsView.frame.width)
            pageControl.numberOfPages = portfolioImageUrls.count
            pageControl.isHidden = portfolioImageUrls.count <= 1
        }
    }
    @objc private func didChangeValue(segment: UISegmentedControl) {
        currentSegmentIndex = segment.selectedSegmentIndex
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

//MARK: - UIScrollViewDelegate
extension ModelReservationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == backgroundImageScrollView {
            let page = Int(round(scrollView.contentOffset.x / view.frame.width))
            pageControl.currentPage = page
        } else {
            let outerScroll = scrollView == scrollView
            let innerScroll = !outerScroll
            let moreScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
            let lessScroll = !moreScroll
            
            let outerScrollMaxOffsetY = scrollView.contentSize.height - scrollView.frame.height
            let innerScrollMaxOffsetY = reviewView.innerScrollView.contentSize.height - reviewView.innerScrollView.frame.height
            
            guard outerScroll else { return }
            
            // outer scroll을 more scroll 다 했으면, inner scroll을 more scroll
            if outerScroll && moreScroll {
                guard outerScrollMaxOffsetY < scrollView.contentOffset.y + ShowReviewView.Policy.floatingPointTolerance else { return }
                reviewView.innerScrollingDownDueToOuterScroll = true
                defer { reviewView.innerScrollingDownDueToOuterScroll = false }
                
                guard reviewView.innerScrollView.contentOffset.y < innerScrollMaxOffsetY else { return }
                
                reviewView.innerScrollView.contentOffset.y = reviewView.innerScrollView.contentOffset.y + scrollView.contentOffset.y - outerScrollMaxOffsetY
                scrollView.contentOffset.y = outerScrollMaxOffsetY
            }
            
            // inner scroll이 less 스크롤 할게 남아 있다면 inner scroll을 less 스크롤
            if outerScroll && lessScroll {
                guard reviewView.innerScrollView.contentOffset.y > 0 && scrollView.contentOffset.y < outerScrollMaxOffsetY else { return }
                reviewView.innerScrollingDownDueToOuterScroll = true
                defer { reviewView.innerScrollingDownDueToOuterScroll = false }
                
                reviewView.innerScrollView.contentOffset.y = max(reviewView.innerScrollView.contentOffset.y - (outerScrollMaxOffsetY - scrollView.contentOffset.y), 0)
                
                scrollView.contentOffset.y = outerScrollMaxOffsetY
            }

            // inner scroll을 모두 less scroll한 경우, outer scroll을 less scroll
            if innerScroll && lessScroll {
                defer { reviewView.innerScrollView.lastOffsetY = reviewView.innerScrollView.contentOffset.y }
                guard reviewView.innerScrollView.contentOffset.y < 0 && scrollView.contentOffset.y > 0 else { return }
                
                guard reviewView.innerScrollView.lastOffsetY > reviewView.innerScrollView.contentOffset.y else { return }
                
                let moveOffset = outerScrollMaxOffsetY - abs(reviewView.innerScrollView.contentOffset.y) * 3
                guard moveOffset < scrollView.contentOffset.y else { return }
                
                scrollView.contentOffset.y = max(moveOffset, 0)
            }
            
            // outer scroll이 아직 more 스크롤할게 남아 있다면, innerScroll을 그대로 두고 outer scroll을 more 스크롤
            if innerScroll && moreScroll {
                guard
                    scrollView.contentOffset.y + ShowReviewView.Policy.floatingPointTolerance < outerScrollMaxOffsetY,
                    !reviewView.innerScrollingDownDueToOuterScroll
                else { return }
                let minOffetY = min(scrollView.contentOffset.y + reviewView.innerScrollView.contentOffset.y, outerScrollMaxOffsetY)
                let offsetY = max(minOffetY, 0)
                scrollView.contentOffset.y = offsetY
                
                    reviewView.innerScrollView.contentOffset.y = 0
            }
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

private struct AssociatedKeys {
    static var lastOffsetY = "lastOffsetY"
}

extension UIScrollView {
    var lastOffsetY: CGFloat {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.lastOffsetY) as? CGFloat) ?? contentOffset.y
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lastOffsetY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

//MARK: -API 통신 메소드
extension ModelReservationViewController {
    func postFavoritePortfolio(modelId: Int, portfolioId: Int) {
        MyPageManager.shared.postFavoritePortfolio(modelId: modelId, portfolioId: portfolioId) { [weak self] result in
            switch result {
            case .success(let response):
                self!.likeImageView.image = UIImage(named: "icon_fillLike")
                self!.isFavorite = true
                print("관심 메이크업 추가 성공: \(response.message)")
            case .failure(let error):
                self!.likeImageView.image = UIImage(named: "icon_like")
                self!.isFavorite = false
                if let responseData = error.response {
                    let responseString = String(data: responseData.data, encoding: .utf8)
                    print("관심 메이크업 추가 실패: \(responseString ?? "no data")")
                }
            }
        }

    }
    func deleteFavoritePortfolio(modelId: Int, portfolioId: Int) {
        MyPageManager.shared.deleteFavoritePortfolio(modelId: modelId, portfolioId: portfolioId) { [weak self] result in
            switch result {
            case .success(let response):
                self!.likeImageView.image = UIImage(named: "icon_like")
                self!.isFavorite = false
                print("관심 메이크업 삭제 성공: \(response.message)")
            case .failure(let error):
                self!.likeImageView.image = UIImage(named: "icon_fillLike")
                self!.isFavorite = true
                if let responseData = error.response {
                    let responseString = String(data: responseData.data, encoding: .utf8)
                    print("관심 메이크업 삭제 실패: \(responseString ?? "no data")")
                }
            }
        }
        
    }
    private func fetchPortfolioDetail(userId: Int, portfolioId: Int) {
        PortfolioManager.shared.getPortfolioDetail(userId: userId, portfolioId: portfolioId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let portfolioDetail):
                    if let jsonData = try? JSONEncoder().encode(portfolioDetail),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("포트폴리오 세부 조회 완료: \(jsonString)")
                        self?.displayPortfolioDetail(portfolioDetail)
                    } else {
                        print("데이터 format 실패")
                    }
                    
                case .failure(let error):
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("포트폴리오 세부 조회 실패: \(responseString ?? "no data")")
                    }
                }
            }
        }
    }
    
    // MARK: - Enum 처리
    enum MakeupCategory: String {
        case DAILY
        case ACTOR
        case INTERVIEW
        case PARTY
        case WEDDING
        case PROSTHETIC
        case STUDIO
        case ETC
    }
    enum CategoryToMakeupExplain: String {
        case DAILY
        case ACTOR
        case INTERVIEW
        case PARTY
        case WEDDING
        case PROSTHETIC
        case STUDIO
        case ETC
    }
    enum EmploymentStatus: String {
        case SHOP
        case VISIT
        case BOTH
    }
    
    private func displayPortfolioDetail(_ portfolioDetail: PortfolioDTO) {
        if let imageDTOs = portfolioDetail.data?.portfolioImgDtoList {
            for imageDTO in imageDTOs {
                portfolioImageUrls.append(imageDTO.portfolioImgSrc)
            }
        }
        if let profileImgURLString = portfolioDetail.data?.artistProfileImg,
           let profileImgURL = URL(string: profileImgURLString) {
            downloadImage(from: profileImgURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }
        } else {
            profileImageView.image = UIImage(named: "modelProfile")
        }
        
        artistName = portfolioDetail.data?.artistNickName
        artistNameLabel.text = portfolioDetail.data?.artistNickName
        makeupName = portfolioDetail.data?.makeupName
        makeupNameLabel.text = portfolioDetail.data?.makeupName
        
        if let categoryToMakeupExplainString = portfolioDetail.data?.makeupLocation,
           let categoryToMakeupExplain = CategoryToMakeupExplain(rawValue: categoryToMakeupExplainString) {
            switch categoryToMakeupExplain {
            case .DAILY:
                makeupExplainLabel.text = "데일리 메이크업으로 좋아요"
            case .ACTOR:
                makeupExplainLabel.text = "배우/촬영하실 때 좋아요"
            case .INTERVIEW:
                makeupExplainLabel.text = "면접가실 때 좋아요"
            case .PARTY:
                makeupExplainLabel.text = "파티 참여할 때 좋아요"
            case .WEDDING:
                makeupExplainLabel.text = "결혼식/웨딩 촬영에 좋아요"
            case .PROSTHETIC:
                makeupExplainLabel.text = "특수 분장하실 때 좋아요"
            case .STUDIO:
                makeupExplainLabel.text = "스튜디오 찰영가실 때 좋아요"
            case .ETC:
                makeupExplainLabel.text = "기타 메이크업에 좋아요"
            }
        } else {
            makeupExplainLabel.text = "메이크업 설명 없음"
        }
        if let isFavorite = portfolioDetail.data?.isFavorite {
            self.isFavorite = isFavorite
        }
        likeImageDecision()
        if let employmentStatusString = portfolioDetail.data?.makeupLocation,
           let employmentStatus = EmploymentStatus(rawValue: employmentStatusString) {
            switch employmentStatus {
            case .SHOP:
                aEmploymentStatusLabel.text = "🙋🏻샵에 재직 중이에요"
            case .VISIT:
                aEmploymentStatusLabel.text = "🙅🏻프리랜서에요"
            case .BOTH:
                aEmploymentStatusLabel.text = "🙆🏻샵, 방문 다 가능해요"
            }
        } else {
            aEmploymentStatusLabel.text = "직업 상태 없음"
        }
        
        if let categoryString = portfolioDetail.data?.category,
           let category = MakeupCategory(rawValue: categoryString) {
            switch category {
            case .DAILY:
                aCategoryLabel.text = "데일리 메이크업"
            case .ACTOR:
                aCategoryLabel.text = "배우 메이크업"
            case .INTERVIEW:
                aCategoryLabel.text = "면접 메이크업"
            case .PARTY:
                aCategoryLabel.text = "파티/이벤트 메이크업"
            case .WEDDING:
                aCategoryLabel.text = "웨딩 메이크업"
            case .PROSTHETIC:
                aCategoryLabel.text = "특수 메이크업"
            case .STUDIO:
                aCategoryLabel.text = "스튜디오 메이크업"
            case .ETC:
                aCategoryLabel.text = "기타 메이크업"
            }
        } else {
            aCategoryLabel.text = "카테고리 없음"
        }
        
        
        if let info = portfolioDetail.data?.info {
            informationView.configure(infoText: info)
        }
        if let reviewCount = portfolioDetail.data?.reviewCount {
            segmentedControl.setReviewCount(reviewCount)
        }
        //아티스트 아이디 추가 필요
    }
        
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
