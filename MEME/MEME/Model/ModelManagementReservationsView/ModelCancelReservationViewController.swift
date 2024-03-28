//
//  ModelCancelReservationViewController.swift
//  MEME
//
//  Created by 정민지 on 3/27/24.
//

import UIKit
import SnapKit

class ModelCancelReservationViewController: UIViewController, BackButtonTappedDelegate {
    // MARK: - Properties
    var reservationId: Int?
    var portfolioId: Int?
    var reservationDate: String?
    
    private var isToday: Bool = false
    
    private var portfolioData: [PortfolioData] = []
    
    private let navigationBar = NavigationBarView()
    private var artistProfileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profile"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds =  true
        imageView.layer.cornerRadius = 75/2
        
        return imageView
    }()
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트 차차"
        label.font = .pretendard(to: .semiBold, size: 18)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    private var whatMakeupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업명"
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var makeupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업명"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var whatCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "분야"
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "배우 메이크업"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    
    private var whereLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "메이크업 장소명"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var showArtistPortfolioLabel: UILabel = {
        let label = UILabel()
        label.text = "관련 포트폴리오 보기"
        label.font = .pretendard(to: .medium, size: 16)
        label.textColor = .black
        
        return label
    }()
    private lazy var relatedPortfolioCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "SelectMakeupCardViewCell", bundle: nil), forCellWithReuseIdentifier: SelectMakeupCardViewCell.identifier)
        
        return collectionView
    }()

    
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("예약 취소하기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.delegate = self
        navigationBar.configure(title: "전체 예약 보기")

        configureSubviews()
        makeConstraints()
        setupReservationDate()
        
        if let reservationId = reservationId {
            getModelDetailReservation(reservationId: reservationId)
        }
        if let portfolioId = portfolioId {
            getRelatedPortfolio(userId: 1, portfolioId: portfolioId)
        }
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(artistProfileImageView)
        view.addSubview(artistNameLabel)
        view.addSubview(whatMakeupNameLabel)
        view.addSubview(makeupNameLabel)
        view.addSubview(whatCategoryLabel)
        view.addSubview(categoryLabel)
        view.addSubview(whereLocationLabel)
        view.addSubview(locationLabel)
        view.addSubview(showArtistPortfolioLabel)
        view.addSubview(relatedPortfolioCollectionView)
        view.addSubview(cancelButton)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBar.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        artistProfileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom).offset(24)
            make.width.height.equalTo(75)
            make.centerX.equalToSuperview()
            
        }
        artistNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistProfileImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        whatMakeupNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(17)
            make.leading.equalToSuperview().offset(50)
        }
        makeupNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(whatMakeupNameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-50)
        }
        whatCategoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(whatMakeupNameLabel.snp.bottom).offset(17)
            make.leading.equalToSuperview().offset(50)
        }
        categoryLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(whatCategoryLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-50)
        }
        whereLocationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(whatCategoryLabel.snp.bottom).offset(17)
            make.leading.equalToSuperview().offset(50)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(whereLocationLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-50)
        }
        showArtistPortfolioLabel.snp.makeConstraints { (make) in
            make.top.equalTo(whereLocationLabel.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(50)
        }
        relatedPortfolioCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(showArtistPortfolioLabel.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().offset(50)
            make.height.equalTo(260)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
    }
    // MARK: - Action
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func cancelTapped() {
        let alert = UIAlertController(title: "예약 취소하기", message: "\n예약을 취소하시겠습니까? 취소 시 아티스트에게 취소 알림이 전송됩니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            guard let self = self, let reservationId = self.reservationId else { return }
            self.patchReservation(reservationId: reservationId)
            self.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: -Method
    func setupReservationDate() {
        guard let reservationDateString = reservationDate else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        if let date = dateFormatter.date(from: reservationDateString) {
            let calendar = Calendar.current
            isToday = calendar.isDateInToday(date)
            updateCancelButtonUI()
        }
    }
    
    func updateCancelButtonUI() {
        if isToday {
            cancelButton.backgroundColor = .gray
            cancelButton.setTitle("당일 예약은 취소가 불가능합니다", for: .normal)
            cancelButton.isEnabled = false
        } else {
            cancelButton.backgroundColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            cancelButton.setTitle("예약 취소하기", for: .normal)
            cancelButton.isEnabled = true
        }
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ModelCancelReservationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolioData.count
    }
    
    
    //cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectMakeupCardViewCell.identifier, for: indexPath) as? SelectMakeupCardViewCell else {
            fatalError("셀 타입 캐스팅 실패...")
        }
        let portfolioData = portfolioData[indexPath.item]
        cell.configureWithPortfolio(portfolioData)
        return cell
    }
}
extension ModelCancelReservationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 154, height: 222)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let reservationVC = ModelReservationViewController()
        let portfolioID = portfolioData[indexPath.row].portfolioId
            reservationVC.portfolioID = portfolioID
            reservationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(reservationVC, animated: true)
    }
}

//MARK: -API 통신 메소드
extension ModelCancelReservationViewController {
    private func getModelDetailReservation(reservationId: Int) {
        ReservationManager.shared.getModelDetailReservation(reservationId: reservationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ReservationDetail):
                    if let jsonData = try? JSONEncoder().encode(ReservationDetail),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("모델 예약 상세 조회 완료: \(jsonString)")
                        self?.displayReservationDetail(ReservationDetail)
                    } else {
                        print("데이터 format 실패")
                    }
                    
                case .failure(let error):
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("모델 예약 상세 조회 실패: \(responseString ?? "no data")")
                    }
                }
            }
        }
    }
    private func getRelatedPortfolio(userId: Int, portfolioId: Int) {
//        PortfolioManager.shared.getPortfolioDetail(userId: userId, portfolioId: portfolioId) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let portfolioDetail):
//                    if let jsonData = try? JSONEncoder().encode(portfolioDetail),
//                       let jsonString = String(data: jsonData, encoding: .utf8) {
//                        print("포트폴리오 세부 조회 완료: \(jsonString)")
//                        if let data = portfolioDetail.data {
//                            self?.portfolioData = [data]
//                            self?.relatedPortfolioCollectionView.reloadData()
//                        }
//                    } else {
//                        print("데이터 format 실패")
//                    }
//                    
//                case .failure(let error):
//                    if let responseData = error.response {
//                        let responseString = String(data: responseData.data, encoding: .utf8)
//                        print("포트폴리오 세부 조회 실패: \(responseString ?? "no data")")
//                    }
//                }
//            }
//        }
    }
    private func patchReservation(reservationId: Int) {
        ReservationManager.shared.patchReservation(
            reservationId: reservationId,
            status: .CANCEL
            ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("예약 상태 변경 성공: \(response)")
                case .failure(let error):
                    print("예약 상태 변경 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func displayReservationDetail(_ reservationDetail: ReservationDetailDTO) {
        
        if let profileImgURLString = reservationDetail.data.artistProfileImg,
           let profileImgURL = URL(string: profileImgURLString) {
            downloadImage(from: profileImgURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.artistProfileImageView.image = image
                }
            }
        } else {
            artistProfileImageView.image = UIImage(named: "profile")
        }
        
        artistNameLabel.text = reservationDetail.data.artistNickName
        makeupNameLabel.text = reservationDetail.data.portfolioName
        
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
        
        if let categoryToMakeupExplain = CategoryToMakeupExplain(rawValue: reservationDetail.data.category) {
            switch categoryToMakeupExplain {
            case .DAILY:
                categoryLabel.text = "데일리 메이크업"
            case .ACTOR:
                categoryLabel.text = "배우 메이크업"
            case .INTERVIEW:
                categoryLabel.text = "면접 메이크업"
            case .PARTY:
                categoryLabel.text = "파티 메이크업"
            case .WEDDING:
                categoryLabel.text = "웨딩 메이크업"
            case .PROSTHETIC:
                categoryLabel.text = "특수 메이크업"
            case .STUDIO:
                categoryLabel.text = "스튜디오 메이크업"
            case .ETC:
                categoryLabel.text = "기타 메이크업"
            }
        } else {
            categoryLabel.text = "해당 분야 없음"
        }

        locationLabel.text = reservationDetail.data.location
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
