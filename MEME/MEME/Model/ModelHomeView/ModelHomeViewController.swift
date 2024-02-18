//
//  ViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import SnapKit
import Moya

final class ModelHomeViewController: UIViewController {
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private var memeLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var alarmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon _bell")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let searchMakeup: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "원하는 메이크업을 검색해보세요."
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.mainBold.cgColor
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        let textField = searchBar.searchTextField
            textField.backgroundColor = .white
            textField.textColor = .black
        
        if let leftView = textField.leftView as? UIImageView {
            leftView.tintColor = .mainBold
            }
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainBold]
            textField.attributedPlaceholder = NSAttributedString(string: "원하는 메이크업을 검색해보세요.", attributes: placeholderAttributes)
        searchBar.tintColor = .mainBold
        
        return searchBar
    }()

    private var modelWelcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "000 님, 환영합니다!"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 20)
        label.numberOfLines = 0
        
        return label
    }()
    private var modelWelcomeGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트와의 약속 놓치지 마세요!"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 20)
        
        return label
    }()
    private var viewAllReservationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 예약 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        if let image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
            button.setImage(image, for: .normal)
        }
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(viewAllReservationsTapped), for: .touchUpInside)

        return button
    }()

    private var modelReservationCollectionView: UICollectionView!
    private var recomandArtistReservationMainLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 아티스트를 선택할 지 모르겠을 때"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 20)
        
        return label
    }()
    private var recomandArtistReservationSubLabel: UILabel = {
        let label = UILabel()
        label.text = "후기가 많은 아티스트를 만나봐요"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        return label
    }()
    private var recomandReservationCollectionView: UICollectionView!
    private var recomandHastyReservationMainLabel: UILabel = {
        let label = UILabel()
        label.text = "급하게 메이크업이 필요할 때"
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 20)
        
        return label
    }()
    private var recomandHastyReservationSubLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘, 내일 바로 예약 가능한 아티스트를 알아봐요"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        return label
    }()
    private var recomandHastyReservationCollectionView: UICollectionView!
    
    private var modelReservations: [ReservationData]? {
        didSet { self.modelReservationCollectionView.reloadData() }
    }
    private var makeupCards: [Portfolio]? {
        didSet { self.recomandReservationCollectionView.reloadData() }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        showModelReservations()
        setupReservationCollectionView()
        setupMakeupCardCollectionView()
        setupHastyMakeupCardCollectionView()
        configureSubviews()
        makeConstraints()
        setupSearchBar()
        
        getRecommendArtistByReview()
        getRecommendArtistByRecent()
        
    }
    // MARK: - configureSubviews
    func configureSubviews() {
        contentsView.addSubview(memeLogoImageView)
        contentsView.addSubview(alarmImageView)
        contentsView.addSubview(searchMakeup)
        contentsView.addSubview(modelWelcomeLabel)
        contentsView.addSubview(modelWelcomeGuideLabel)
        contentsView.addSubview(viewAllReservationsButton)
        modelReservationCollectionView.backgroundColor = .white
        contentsView.addSubview(modelReservationCollectionView)
        contentsView.addSubview(recomandArtistReservationMainLabel)
        contentsView.addSubview(recomandArtistReservationSubLabel)
        recomandReservationCollectionView.backgroundColor = .white
        contentsView.addSubview(recomandReservationCollectionView)
        contentsView.addSubview(recomandHastyReservationMainLabel)
        contentsView.addSubview(recomandHastyReservationSubLabel)
        recomandHastyReservationCollectionView.backgroundColor = .white
        contentsView.addSubview(recomandHastyReservationCollectionView)
        scrollView.addSubview(contentsView)
        view.addSubview(scrollView)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        memeLogoImageView.snp.makeConstraints {make in
            make.top.equalTo(contentsView.snp.top).offset(10)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.height.equalTo(42)
            make.width.equalTo(memeLogoImageView.snp.height).multipliedBy(67.0/42.0)
        }
        alarmImageView.snp.makeConstraints {make in
            make.centerY.equalTo(memeLogoImageView.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(22)
            make.width.equalTo(memeLogoImageView.snp.height).multipliedBy(6.0/7.0)
        }
        searchMakeup.snp.makeConstraints {make in
            make.top.equalTo(memeLogoImageView.snp.bottom).offset(27)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(41)
        }
        modelWelcomeLabel.snp.makeConstraints {make in
            make.top.equalTo(searchMakeup.snp.bottom).offset(33)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        modelWelcomeGuideLabel.snp.makeConstraints {make in
            make.top.equalTo(modelWelcomeLabel.snp.bottom)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        viewAllReservationsButton.snp.makeConstraints {make in
            make.top.equalTo(modelWelcomeGuideLabel.snp.bottom).offset(17)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        modelReservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(viewAllReservationsButton.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(150)
        }
        recomandArtistReservationMainLabel.snp.makeConstraints {make in
            make.top.equalTo(modelReservationCollectionView.snp.bottom).offset(44)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        recomandArtistReservationSubLabel.snp.makeConstraints {make in
            make.top.equalTo(recomandArtistReservationMainLabel.snp.bottom).offset(7)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        recomandReservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(recomandArtistReservationSubLabel.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(260)
        }
        recomandHastyReservationMainLabel.snp.makeConstraints {make in
            make.top.equalTo(recomandReservationCollectionView.snp.bottom).offset(24)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        recomandHastyReservationSubLabel.snp.makeConstraints {make in
            make.top.equalTo(recomandHastyReservationMainLabel.snp.bottom).offset(7)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        recomandHastyReservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(recomandHastyReservationSubLabel.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(260)
            make.bottom.equalTo(contentsView.snp.bottom)
        }
        
    }
    //MARK: -Actions
    func setupSearchBar() {
        searchMakeup.delegate = self
    }
    @objc private func viewAllReservationsTapped() {
        let reservationsVC = ModelManagementReservationsViewController()
        reservationsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(reservationsVC, animated: true)
    }

    
    //MARK: -Helpers
    private func setupReservationCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        modelReservationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        modelReservationCollectionView.delegate = self
        modelReservationCollectionView.dataSource = self
        
        //cell 등록
        modelReservationCollectionView.register(ModelNonReservationViewCell.self, forCellWithReuseIdentifier: ModelNonReservationViewCell.identifier)
        
        modelReservationCollectionView.register(UINib(nibName: "ModelReservationConfirmViewCell", bundle: nil), forCellWithReuseIdentifier: ModelReservationConfirmViewCell.identifier)

    }

    private func setupMakeupCardCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        recomandReservationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        recomandReservationCollectionView.delegate = self
        recomandReservationCollectionView.dataSource = self
        
        //cell 등록
        recomandReservationCollectionView.register(UINib(nibName: "SelectMakeupCardViewCell", bundle: nil), forCellWithReuseIdentifier: SelectMakeupCardViewCell.identifier)
    }

    private func setupHastyMakeupCardCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        recomandHastyReservationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        //delegate 연결
        recomandHastyReservationCollectionView.delegate = self
        recomandHastyReservationCollectionView.dataSource = self
    
        //cell 등록
        recomandHastyReservationCollectionView.register(UINib(nibName: "SelectMakeupCardViewCell", bundle: nil), forCellWithReuseIdentifier: SelectMakeupCardViewCell.identifier)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ModelHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == modelReservationCollectionView {
            return 2
            } else if collectionView == recomandReservationCollectionView {
                return 1
            } else if collectionView == recomandHastyReservationCollectionView {
                return 1
            }
            return 0
    }
    
    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == modelReservationCollectionView {
            switch section {
            case 0:
                return modelReservations?.count ?? 0
            default:
                return 0
            }
           } else if collectionView == recomandReservationCollectionView {
               return makeupCards?.count ?? 0
           } else if collectionView == recomandHastyReservationCollectionView {
               return makeupCards?.count ?? 0
           }
           return 0
        
    }
    
    
    //cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == modelReservationCollectionView {
            if indexPath.section == 0 {
                if modelReservations?.isEmpty ?? true {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelNonReservationViewCell.identifier, for: indexPath) as? ModelNonReservationViewCell else {
                        fatalError("셀 타입 캐스팅 실패...")
                    }
                    
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.identifier, for: indexPath) as? ModelReservationConfirmViewCell, let reservation = modelReservations?[indexPath.row] else {
                        fatalError("셀 타입 캐스팅 실패...")
                    }
                    cell.configure(with: reservation)
                    return cell
                }
            }
        } else if collectionView == recomandReservationCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectMakeupCardViewCell.identifier, for: indexPath) as? SelectMakeupCardViewCell, let card = makeupCards?[indexPath.row] else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.configure(with: card)
            return cell
        } else if collectionView == recomandHastyReservationCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectMakeupCardViewCell.identifier, for: indexPath) as? SelectMakeupCardViewCell, let card = makeupCards?[indexPath.row] else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.configure(with: card)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ModelHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == modelReservationCollectionView {
            return CGSize(
                width: collectionView.frame.width, height: 142)
        } else if collectionView == recomandReservationCollectionView {
            return CGSize(width: 154, height: 222)
        } else if collectionView == recomandHastyReservationCollectionView {
            return CGSize(width: 154, height: 222)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == modelReservationCollectionView {
            return CGFloat(20)
        }
        else if collectionView == recomandReservationCollectionView {
            return CGFloat(10)
        }
        else if collectionView == recomandHastyReservationCollectionView {
            return CGFloat(10)
        }
        return CGFloat(20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recomandReservationCollectionView || collectionView == recomandHastyReservationCollectionView  {
            let reservationVC = ModelReservationViewController()
            let portfolioID = makeupCards?[indexPath.row].portfolioId
            reservationVC.portfolioID = portfolioID
            reservationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(reservationVC, animated: true)
        } 
    }
}

//MARK: - UISearchBarDelegate
extension ModelHomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = ModelSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
        return false
    }
}

//MARK: -API 통신 메소드
extension ModelHomeViewController {
    func showModelReservations() {
        ReservationManager.shared.getModelReservation(modelId: 6) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservationResponse):
                    print("모델 예약 정보 조회 성공: \(reservationResponse)")
                    let filteredReservations = reservationResponse.data?.filter { reservationData in
                        let reservationDate = self?.dateFromString(reservationData.reservationDate)
                        let isToday = self?.isToday(reservationDate) ?? false
                        let isExpected = reservationData.status == "EXPECTED"
                        return isToday && isExpected
                    }
                    self?.modelReservations = filteredReservations
                    self?.modelReservationCollectionView.reloadData()
                    
                case .failure(let error):
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("모델 예약 정보 조회 실패: \(responseString ?? "no data")")
                    }
                }
            }
        }
    }
    func getRecommendArtistByReview() {
        RecommendManager.shared.getRecommendArtistByReview { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recommendResponse):
                    self?.makeupCards = recommendResponse.data
                    self?.recomandReservationCollectionView.reloadData()
                    print("아티스트 추천 (리뷰순) 조회 성공: \(recommendResponse)")
                case .failure(let error):
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("아티스트 추천 (리뷰순) 조회 실패: \(responseString ?? "no data")")
                    }
                }
            }
        }
    }
    
    func getRecommendArtistByRecent() {
        RecommendManager.shared.getRecommendArtistByRecent { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.makeupCards = response.data
                    self?.recomandHastyReservationCollectionView.reloadData()
                    print("아티스트 추천 (최신 등록 순) 조회 성공: \(response)")
                case .failure(let error):
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("아티스트 추천 (최신 등록 순) 조회 실패: \(responseString ?? "no data")")
                    }
                }
            }
        }
    }
    func dateFromString(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: dateString)
        return date
    }

    
    func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        print(Calendar.current.isDateInToday(date))
        return Calendar.current.isDateInToday(date)
    }
}
