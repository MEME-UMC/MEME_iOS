//
//  ModelSearchViewController.swift
//  MEME
//
//  Created by 정민지 on 1/15/24.
//

import UIKit

protocol ModelSearchViewControllerDelegate: AnyObject {
    func didEnterSearchKeyword(_ keyword: String)
}

struct ArtistModel {
    let artistNickName: String
    let artistId: Int
}

class ModelSearchViewController: UIViewController {
    //MARK: -Properties
    private var favoriteArtists: [ArtistModel] = []
    private var artistIdForButton: [UIButton: Int] = [:]
    
    private var navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    private var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        
        return button
    }()
    
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
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
    private var recentSearchKeywords: [String] = []
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        
        return stack
    }()
    private var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var allCancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 12)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(clearRecentSearches), for: .touchUpInside)

        return button
    }()
    private let categorySearchesData = [("icon_daily", "데일리 메이크업"), ("icon_actor", "배우 메이크업"), ("icon_interview", "면접 메이크업"), ("icon_party", "파티/이벤트\n메이크업"), ("icon_wedding", "웨딩 메이크업"), ("icon_special", "특수 메이크업"), ("icon_studio", "스튜디오\n메이크업"), ("icon_etc", "기타(속눈썹,\n퍼스널 컬러)")]
    private var recentSearchesCollectionView: UICollectionView!
    private var categorySearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리로 찾기"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private var categorySearchesCollectionView: UICollectionView!
    private var artistSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 아티스트로 찾기"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private let artistsVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let artistsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()

    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupDismissKeyboardOnTapGesture()
        
        fetchFavoriteArtists()
        setupSearchCollectionView()
        setupRecentSearchCollectionView()
        setupSearchMakeupBar()
        configureSubviews()
        makeConstraints()
        setupArtistsButtons()
        
        recentSearchKeywords = loadSearchKeywords()
        recentSearchesCollectionView.reloadData()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBarView)
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(searchMakeup)
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(recentSearchesLabel)
        contentsView.addSubview(allCancelButton)
        recentSearchesCollectionView.backgroundColor = .white
        contentsView.addSubview(recentSearchesCollectionView)
        contentsView.addSubview(categorySearchesLabel)
        categorySearchesCollectionView.backgroundColor = .white
        contentsView.addSubview(categorySearchesCollectionView)
        contentsView.addSubview(artistSearchesLabel)
        contentsView.addSubview(artistsVerticalStackView)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBarView.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        backButton.snp.makeConstraints {make in
            make.leading.equalTo(navigationBarView.snp.leading).offset(24)
            make.centerY.equalTo(navigationBarView.snp.centerY)
            make.width.equalTo(24)
        }
        searchMakeup.snp.makeConstraints {make in
            make.centerY.equalTo(navigationBarView.snp.centerY)
            make.leading.equalTo(backButton.snp.trailing).offset(13)
            make.trailing.equalTo(navigationBarView.snp.trailing).offset(-24.26)
            make.height.equalTo(40)
        }
        
        scrollView.snp.makeConstraints {make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        recentSearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(contentsView.snp.top).offset(38)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        allCancelButton.snp.makeConstraints {make in
            make.centerY.equalTo(recentSearchesLabel.snp.centerY)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        recentSearchesCollectionView.snp.makeConstraints {make in
            make.top.equalTo(recentSearchesLabel.snp.bottom).offset(3)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(30)
        }
        categorySearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(recentSearchesCollectionView.snp.bottom).offset(31)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        categorySearchesCollectionView.snp.makeConstraints {make in
            make.top.equalTo(categorySearchesLabel.snp.bottom).offset(9)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(450)
        }
        artistSearchesLabel.snp.makeConstraints {make in
            make.top.equalTo(categorySearchesCollectionView.snp.bottom).offset(27)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        artistsVerticalStackView.snp.makeConstraints {make in
            make.top.equalTo(artistSearchesLabel.snp.bottom).offset(9)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.bottom.equalTo(contentsView.snp.bottom).offset(-72)
        }
    }

    // MARK: - Navigation
    
    //MARK: -Actions
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func artistButtonTapped(_ sender: UIButton) {
        guard let artistId = artistIdForButton[sender] else { return }
        
        let searchResultVC = ModelSearchResultViewController()
        searchResultVC.selectedArtistId = artistId
        navigationController?.pushViewController(searchResultVC, animated: true)
    }

    private func executeSearch(with searchText: String) {
        searchBarSearchButtonClicked(searchMakeup)
    }
    
    
    //MARK: -Helpers
    private func setupSearchMakeupBar() {
        searchMakeup.delegate = self
    }
    private func setupRecentSearchCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        recentSearchesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        recentSearchesCollectionView.delegate = self
        recentSearchesCollectionView.dataSource = self
        
        //cell 등록
        recentSearchesCollectionView.register(UINib(nibName: "RecentSearchViewCell", bundle: nil), forCellWithReuseIdentifier: RecentSearchViewCell.identifier)
    }
    private func setupSearchCollectionView() {
        let layout = UICollectionViewFlowLayout()
        categorySearchesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        categorySearchesCollectionView.delegate = self
        categorySearchesCollectionView.dataSource = self
        
        //cell 등록
        categorySearchesCollectionView.register(UINib(nibName: "CategorySearchViewCell", bundle: nil), forCellWithReuseIdentifier: CategorySearchViewCell.identifier)
    }
    
    private func maxNumberOfButtonsPerRow() -> Int {
        let viewWidth = self.view.bounds.width
        let buttonWidth: CGFloat = 70
        let buttonSpacing: CGFloat = 5
        let sidePadding: CGFloat = 24 * 2
        let availableWidth = viewWidth - sidePadding
        let maxButtons = Int(availableWidth / (buttonWidth + buttonSpacing))
        
        return maxButtons
    }
    
    private func setupArtistsButtons() {
        var currentStackView = createNewHorizontalStackView()
        artistsVerticalStackView.addArrangedSubview(currentStackView)
        
        for artist in favoriteArtists {
            let button = createButton(with: artist.artistNickName)
            artistIdForButton[button] = artist.artistId
            
            if currentStackView.arrangedSubviews.count >= maxNumberOfButtonsPerRow() {
                currentStackView = createNewHorizontalStackView()
                artistsVerticalStackView.addArrangedSubview(currentStackView)
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
                emptySpaceView.widthAnchor.constraint(equalToConstant: 70).isActive = true
                stackView.addArrangedSubview(emptySpaceView)
            }
        }
    }

    private func createNewVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createButton(with artist: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(artist, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(to: .regular, size: 10)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBold.cgColor
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.addTarget(self, action: #selector(artistButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ModelSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == recentSearchesCollectionView {
            return 1
            }  else if collectionView == categorySearchesCollectionView{
                return 1
            }
        return 1
    }
    
    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentSearchesCollectionView {
            return recentSearchKeywords.count
            }  else if collectionView == categorySearchesCollectionView{
                return 8
            }
        return 0
    }
    
    //cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentSearchesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchViewCell.identifier, for: indexPath) as? RecentSearchViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            let keyword = recentSearchKeywords[indexPath.row]
            cell.configure(with: keyword)
            cell.delegate = self
            print("Delegate has been set for cell with keyword: \(keyword)")
            return cell
            }  else if collectionView == categorySearchesCollectionView{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySearchViewCell.identifier, for: indexPath) as? CategorySearchViewCell else {
                    fatalError("셀 타입 캐스팅 실패...")
                }
                let data = categorySearchesData[indexPath.row]
                cell.categoryImageView.image = UIImage(named: data.0)
                cell.categoryLabel.text = data.1
                return cell
            }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ModelSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recentSearchesCollectionView {
            return CGSize(width: 107, height: 28)
            }  else if collectionView == categorySearchesCollectionView{
                return CGSize(width: 95, height: 137)
            }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categorySearchesCollectionView {
                let totalWidth = collectionView.bounds.width
                let numberOfItemsPerRow: CGFloat = 3
                let cellWidth: CGFloat = 95
                let totalCellWidth = cellWidth * numberOfItemsPerRow
                let totalSpacingWidth = totalWidth - totalCellWidth
                let spacing = totalSpacingWidth / (numberOfItemsPerRow - 1)
                return spacing
            }
            return 10 
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == recentSearchesCollectionView {
            return CGFloat(10)
            }  else if collectionView == categorySearchesCollectionView{
                return CGFloat(7)
            }
        return CGFloat(25)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categorySearchesCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? CategorySearchViewCell
            let category = cell?.categoryLabel.text
            
            let searchResultVC = ModelSearchResultViewController()
            searchResultVC.selectedCategory = category

            navigationController?.pushViewController(searchResultVC, animated: true)
        }
    }
}

extension ModelSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder()
        
        let searchResultVC = ModelSearchResultViewController()
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            saveSearchKeyword(keyword: searchText)
            recentSearchKeywords = loadSearchKeywords()
            recentSearchesCollectionView.reloadData()
            searchResultVC.searchKeyword = searchText
        }
        
        navigationController?.pushViewController(searchResultVC, animated: true)
    }
}

extension ModelSearchViewController {
    func setupDismissKeyboardOnTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


//MARK: - RecentSearchViewCellDelegate
extension ModelSearchViewController: RecentSearchViewCellDelegate {
    //최근 검색어 저장
    func saveSearchKeyword(keyword: String) {
        var keywords = loadSearchKeywords()
        
        if let index = keywords.firstIndex(of: keyword) {
            keywords.remove(at: index)
        }
        
        keywords.insert(keyword, at: 0)
        
        if keywords.count > 10 {
            keywords.removeLast()
        }
        
        UserDefaults.standard.set(keywords, forKey: "recentSearchKeywords")
    }
    
    //최근 검색어 불러오기
    func loadSearchKeywords() -> [String] {
        return UserDefaults.standard.object(forKey: "recentSearchKeywords") as? [String] ?? []
    }
    
    //최근 검색어로 검색
    func didTapSearchWord(keyword: String) {
        let searchResultVC = ModelSearchResultViewController()
        searchResultVC.searchKeyword = keyword
        navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    //최근 검색어 삭제
    func didTapDeleteButton(keyword: String) {
        var keywords = loadSearchKeywords()
        
        if let index = keywords.firstIndex(of: keyword) {
            keywords.remove(at: index)
            UserDefaults.standard.set(keywords, forKey: "recentSearchKeywords")
            recentSearchKeywords = keywords
            recentSearchesCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    //최근 검색어 전체 삭제
    @objc func clearRecentSearches() {
       UserDefaults.standard.set([], forKey: "recentSearchKeywords")
       recentSearchKeywords.removeAll()
       recentSearchesCollectionView.reloadData()
   }
}

//MARK: -API 통신 메소드
extension ModelSearchViewController {
    func fetchFavoriteArtists() {
        // modelId 임의 설정
        let modelId = 6
        
        MyPageManager.shared.getFavoriteArtists(modelId: modelId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let artistsData = response.data, let content = artistsData.content {
                            self?.favoriteArtists = content.map {artistInfo in
                                ArtistModel(
                                    artistNickName: artistInfo.artistNickName,
                                    artistId: artistInfo.artistId)
                            }
                        } else {
                            self?.favoriteArtists = []
                        }
                        self?.setupArtistsButtons()
                        if self?.favoriteArtists.isEmpty == true {
                            self?.artistSearchesLabel.isHidden = true
                        } else {
                            self?.artistSearchesLabel.isHidden = false
                        }
                case .failure(let error):
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("Received error response: \(responseString ?? "no data")")
                    }
                }
            }
        }
    }
}
