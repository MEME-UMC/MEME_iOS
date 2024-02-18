import UIKit
import SnapKit

class ModelViewArtistProfileViewController: UIViewController {
    
    // 예시 데이터 -> 추후 API 호출해서 데이터 받아오는 것으로 수정 필요
    private let expertiseFields = ["데일리 메이크업", "배우 메이크업","면접 메이크업","데일리 메이크업", "배우 메이크업","면접 메이크업"]
    private let isModel : Bool = true
    private var isFavoriteArtist : Bool = true
    var artistID: Int? = 0
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private var artistProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reservation_back")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 87/2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트 차차"
        label.font = .pretendard(to: .semiBold, size: 18)
        label.textColor = .black
        
        return label
    }()
    private var genderBackgroundColorView: UIView = {
        let UIView = UIView()
        UIView.backgroundColor = .white
        UIView.layer.borderColor = UIColor.mainBold.cgColor
        UIView.layer.borderWidth = 1
        UIView.layer.cornerRadius = 19/2
        
        return UIView
    }()
    private var artistGenderLabel: UILabel = {
        let label = UILabel()
        label.text = "여"
        label.font = .pretendard(to: .regular, size: 10)
        label.textColor = .black
        
        return label
    }()
    private var employmentStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "제가 다니는 샵에서 진행해요"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    // 모델에서만 동작
    private let addFavoriteArtistButton: UIButton = {
        let button = UIButton()
        button.setImage(.unfilledFavoriteArtistHeart, for: .normal)
        button.addTarget(self, action: #selector(addFavoriteArtistTapped), for: .touchUpInside)
        return button
    }()
    // 아티스트에서만 동작
    private let artistProfileEditingInfoBar: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 수정은 마이페이지에서 가능해요", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private var artistintroductionLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.font = .pretendard(to: .semiBold, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var inputIntroductionLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요 차차입니다 반갑습니다 메이크업 잘해요\n다들 저에게 와주세요 ㅠㅠ"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    private var totalCareerTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "총 경력 기간"
        label.font = .pretendard(to: .semiBold, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var inputTotalCareerTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "4년"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var availableAreaLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 가능 지역"
        label.font = .pretendard(to: .semiBold, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var shopAvailableAreaBackgroundColorView: UIView = {
        let UIView = UIView()
        UIView.backgroundColor = .mainBold
        UIView.layer.cornerRadius = 19/2
        
        return UIView
    }()
    private var shopLabel: UILabel = {
        let label = UILabel()
        label.text = "샵"
        label.font = .pretendard(to: .regular, size: 10)
        label.textColor = .white
        
        return label
    }()
    private var shopAvailableAreaLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 강남구"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var visitAvailableAreaBackgroundColorView: UIView = {
        let UIView = UIView()
        UIView.backgroundColor = .mainBold
        UIView.layer.cornerRadius = 19/2
        
        return UIView
    }()
    private var visitLabel: UILabel = {
        let label = UILabel()
        label.text = "방문"
        label.font = .pretendard(to: .regular, size: 10)
        label.textColor = .white
        
        return label
    }()
    private var visitAvailableAreaLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 동작구, 영등포구"
        label.font = .pretendard(to: .regular, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var expertiseFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "전문 분야"
        label.font = .pretendard(to: .semiBold, size: 16)
        label.textColor = .black
        
        return label
    }()
    private let expertiseFieldVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let expertiseFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    private var portfolioLabel: UILabel = {
        let label = UILabel()
        label.text = "포트폴리오"
        label.font = .pretendard(to: .semiBold, size: 16)
        label.textColor = .black
        
        return label
    }()
    private var portfolioCollectionView: UICollectionView!
    
    let navigationBar = NavigationBarView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필")
        
        setupPortfolioCollectionView()
        configureSubviews()
        makeConstraints()
        setupExpertiseFieldsButtons()
        updateButtonStatus()
    }
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(artistProfileImageView)
        contentsView.addSubview(artistNameLabel)
        contentsView.addSubview(employmentStatusLabel)
        contentsView.addSubview(genderBackgroundColorView)
        contentsView.addSubview(artistGenderLabel)
        contentsView.addSubview(artistintroductionLabel)
        contentsView.addSubview(inputIntroductionLabel)
        contentsView.addSubview(totalCareerTimeLabel)
        contentsView.addSubview(inputTotalCareerTimeLabel)
        contentsView.addSubview(availableAreaLabel)
        contentsView.addSubview(shopAvailableAreaLabel)
        contentsView.addSubview(shopAvailableAreaBackgroundColorView)
        contentsView.addSubview(shopLabel)
        contentsView.addSubview(visitAvailableAreaLabel)
        contentsView.addSubview(visitAvailableAreaBackgroundColorView)
        contentsView.addSubview(visitLabel)
        contentsView.addSubview(expertiseFieldLabel)
        contentsView.addSubview(expertiseFieldVerticalStackView)
        contentsView.addSubview(portfolioLabel)
        contentsView.addSubview(portfolioCollectionView)
        if(isModel){
            // 하트 버튼으로 수정하기
            contentsView.addSubview(addFavoriteArtistButton)
        }else{
            contentsView.addSubview(artistProfileEditingInfoBar)
        }
        
        
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBar.snp.makeConstraints{ (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        artistProfileImageView.snp.makeConstraints {make in
            make.top.equalTo(contentsView.snp.top).offset(29)
            make.leading.equalTo(contentsView.snp.leading).offset(23)
            make.height.equalTo(87)
            make.width.equalTo(artistProfileImageView.snp.height)
        }
        artistNameLabel.snp.makeConstraints {make in
            make.centerY.equalTo(artistProfileImageView.snp.centerY).multipliedBy(0.8)
            make.leading.equalTo(artistProfileImageView.snp.trailing).offset(20)
        }
        genderBackgroundColorView.snp.makeConstraints {make in
            make.centerY.equalTo(artistNameLabel.snp.centerY)
            make.leading.equalTo(artistNameLabel.snp.trailing).offset(11)
            make.width.equalTo(19)
            make.height.equalTo(19)
        }
        artistGenderLabel.snp.makeConstraints {make in
            make.centerY.equalTo(genderBackgroundColorView.snp.centerY)
            make.centerX.equalTo(genderBackgroundColorView.snp.centerX)
        }
        employmentStatusLabel.snp.makeConstraints {make in
            make.centerY.equalTo(artistProfileImageView.snp.centerY).multipliedBy(1.2)
            make.leading.equalTo(artistProfileImageView.snp.trailing).offset(20)
        }
        
        inputIntroductionLabel.snp.makeConstraints {make in
            make.top.equalTo(artistintroductionLabel.snp.bottom).offset(15)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        totalCareerTimeLabel.snp.makeConstraints {make in
            make.top.equalTo(inputIntroductionLabel.snp.bottom).offset(68)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        inputTotalCareerTimeLabel.snp.makeConstraints {make in
            make.centerY.equalTo(totalCareerTimeLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        availableAreaLabel.snp.makeConstraints {make in
            make.top.equalTo(totalCareerTimeLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        shopAvailableAreaLabel.snp.makeConstraints {make in
            make.centerY.equalTo(availableAreaLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        shopAvailableAreaBackgroundColorView.snp.makeConstraints {make in
            make.centerY.equalTo(shopAvailableAreaLabel.snp.centerY)
            make.trailing.equalTo(shopAvailableAreaLabel.snp.leading).offset(-2)
            make.width.equalTo(19)
            make.height.equalTo(19)
        }
        shopLabel.snp.makeConstraints {make in
            make.centerY.equalTo(shopAvailableAreaBackgroundColorView.snp.centerY)
            make.centerX.equalTo(shopAvailableAreaBackgroundColorView.snp.centerX)
        }
        visitAvailableAreaLabel.snp.makeConstraints {make in
            make.top.equalTo(shopAvailableAreaLabel.snp.bottom).offset(13)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        visitAvailableAreaBackgroundColorView.snp.makeConstraints {make in
            make.centerY.equalTo(visitAvailableAreaLabel.snp.centerY)
            make.trailing.equalTo(visitAvailableAreaLabel.snp.leading).offset(-2)
            make.width.equalTo(24)
            make.height.equalTo(19)
        }
        visitLabel.snp.makeConstraints {make in
            make.centerY.equalTo(visitAvailableAreaBackgroundColorView.snp.centerY)
            make.centerX.equalTo(visitAvailableAreaBackgroundColorView.snp.centerX)
        }
        expertiseFieldLabel.snp.makeConstraints {make in
            make.top.equalTo(availableAreaLabel.snp.bottom).offset(50)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        expertiseFieldVerticalStackView.snp.makeConstraints {make in
            make.top.equalTo(expertiseFieldLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        portfolioLabel.snp.makeConstraints {make in
            make.top.equalTo(expertiseFieldVerticalStackView.snp.bottom).offset(18)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        portfolioCollectionView.snp.makeConstraints {make in
            make.top.equalTo(portfolioLabel.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(260)
            make.bottom.equalTo(contentsView.snp.bottom).offset(-50)
        }
        artistintroductionLabel.snp.makeConstraints {make in
            make.top.equalTo(artistProfileImageView.snp.bottom).offset(38)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        if(isModel) {
            // 하트
            addFavoriteArtistButton.snp.makeConstraints { make in
                make.centerY.equalTo(genderBackgroundColorView.snp.centerY)
                make.leading.equalTo(genderBackgroundColorView.snp.trailing).offset(19)
                make.height.equalTo(18)
            }
        }
        else{
            artistProfileEditingInfoBar.snp.makeConstraints {make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
                make.leading.equalTo(contentsView.snp.leading).offset(24)
                make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
                make.height.equalTo(49)
            }
        }
        
    }
    private func updateButtonStatus() {
        if(isFavoriteArtist){
            addFavoriteArtistButton.setImage(.filledFavoriteArtistHeart, for: .normal)
        }else{
            addFavoriteArtistButton.setImage(.unfilledFavoriteArtistHeart, for: .normal)
        }
    }

    // MARK: - Action
    @objc func closeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func addFavoriteArtistTapped() {
        if isFavoriteArtist {
            if let artistID = artistID {
                deleteFavoriteArtist(modelId: 6, artistId: artistID)
                updateButtonStatus()
            }
        } else {
            if let artistID = artistID {
                postFavoriteArtist(modelId: 6, artistId: artistID)
                updateButtonStatus()
            }
        }
    }
    
    //MARK: -Helpers
    private func maxNumberOfButtonsPerRow() -> Int {
        let viewWidth = self.view.bounds.width
        let buttonWidth: CGFloat = 97
        let buttonSpacing: CGFloat = 7
        let sidePadding: CGFloat = 24 * 2
        let availableWidth = viewWidth - sidePadding
        let maxButtons = Int(availableWidth / (buttonWidth + buttonSpacing))
        
        return maxButtons
    }
    
    private func setupExpertiseFieldsButtons() {
        var currentStackView = createNewHorizontalStackView()
        expertiseFieldVerticalStackView.addArrangedSubview(currentStackView)
        
        for field in expertiseFields {
            let button = createButton(with: field)
            
            if currentStackView.arrangedSubviews.count >= maxNumberOfButtonsPerRow() {
                currentStackView = createNewHorizontalStackView()
                expertiseFieldVerticalStackView.addArrangedSubview(currentStackView)
            }
            currentStackView.addArrangedSubview(button)
        }
        fillRemainingSpaceInLastStackView(currentStackView)
    }

    private func fillRemainingSpaceInLastStackView(_ stackView: UIStackView) {
        let numberOfButtons = stackView.arrangedSubviews.count
        let maxButtonsPerRow = maxNumberOfButtonsPerRow()
        
        if numberOfButtons < maxButtonsPerRow {
            let numberOfEmptySpaces = maxButtonsPerRow - numberOfButtons
            for _ in 0..<numberOfEmptySpaces {
                let emptySpaceView = UIView()
                emptySpaceView.widthAnchor.constraint(equalToConstant: 97).isActive = true
                stackView.addArrangedSubview(emptySpaceView)
            }
        }
    }

    private func createNewVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createButton(with field: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(field, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(to: .regular, size: 10)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBold.cgColor
        button.widthAnchor.constraint(equalToConstant: 97).isActive = true
        button.isEnabled = false
        
        return button
    }
    private func setupPortfolioCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        portfolioCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        //delegate 연결
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
    
        //cell 등록
        portfolioCollectionView.register(UINib(nibName: "SelectMakeupCardViewCell", bundle: nil), forCellWithReuseIdentifier: SelectMakeupCardViewCell.identifier)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ModelViewArtistProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        
    }
    
    //cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectMakeupCardViewCell.identifier, for: indexPath) as? SelectMakeupCardViewCell else {
            fatalError("셀 타입 캐스팅 실패...")
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ModelViewArtistProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 154, height: 222)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
}

//MARK: - BackButtonTappedDelegate
extension ModelViewArtistProfileViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}

extension ModelViewArtistProfileViewController {
    func postFavoriteArtist(modelId: Int, artistId: Int) {
        MyPageManager.shared.postFavoriteArtist(modelId: modelId, artistId: artistId) { [weak self] result in
            switch result {
            case .success(let response):
                self!.isFavoriteArtist = true
                print("관심 아티스트 추가 성공: \(response.message)")
            case .failure(let error):
                self!.isFavoriteArtist = false
                if let responseData = error.response {
                    let responseString = String(data: responseData.data, encoding: .utf8)
                    print("관심 아티스트 추가 실패: \(responseString ?? "no data")")
                }
            }
        }
        
    }
    func deleteFavoriteArtist(modelId: Int, artistId: Int) {
        MyPageManager.shared.deleteFavoriteArtist(modelId: modelId, artistId: artistId) { [weak self] result in
            switch result {
            case .success(let response):
                self!.isFavoriteArtist = false
                print("관심 아티스트 삭제 성공: \(response.message)")
            case .failure(let error):
                self!.isFavoriteArtist = true
                if let responseData = error.response {
                    let responseString = String(data: responseData.data, encoding: .utf8)
                    print("관심 아티스트 삭제 실패: \(responseString ?? "no data")")
                }
            }
        }
        
    }
}
