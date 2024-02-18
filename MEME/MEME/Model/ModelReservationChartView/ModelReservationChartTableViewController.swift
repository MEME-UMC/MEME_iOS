//
//  ModelReservationChartTableViewController.swift
//  MEME
//
//  Created by 정민지 on 1/20/24.
//

import UIKit
import SnapKit

class ModelReservationChartViewController: UIViewController {
    private var selectedButton: ModelReservationTypeButton?
    
    // MARK: - Properties
    var selectedCategory: String?
    var selectedSortOption: String = "리뷰 순"
    
    var currentPage: Int = 0
    var totalPage: Int = 0
    var isLoading: Bool = false
    var searchResults: [SearchResultData] = []
    private var isLastPage: Bool {
        return currentPage >= totalPage-1
    }
    
    var isShowingEmptyState: Bool = false
    
    private var navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    private var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 하기"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 16)
        
        return label
    }()
    
    let buttonScrollView = UIScrollView()
    private let buttonsStackView = UIStackView()
    
    
    private let allButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("전체", for: .normal)

        return button
    }()
    private let specialButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("특수 메이크업", for: .normal)

        return button
    }()
    private let actorButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("배우 메이크업", for: .normal)

        return button
    }()
    private let interviewButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("면접 메이크업", for: .normal)

        return button
    }()
    private let dailyButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("데일리 메이크업", for: .normal)

        return button
    }()
    private let studioButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("스튜디오 메이크업", for: .normal)

        return button
    }()
    private let weddingButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("웨딩 메이크업", for: .normal)

        return button
    }()
    private let partyButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("파티/이벤트 메이크업", for: .normal)
        
        return button
    }()
    private let etcButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("기타 메이크업", for: .normal)

        return button
    }()
    
    private var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    private var numLabel: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.textColor = .black
        label.font = .pretendard(to: .bold, size: 12)
        
        return label
    }()
    private var searchNumLabel: UILabel = {
        let label = UILabel()
        label.text = "개의 검색 결과"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 12)
        
        return label
    }()
    private let sortButton: SortOptionButton = {
        let button = SortOptionButton()
        button.text = "리뷰순"
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "icon_align"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBold.cgColor
        button.layer.cornerRadius = 17
        
        
        return button
    }()
    private var reservationChartTableView: UITableView!
    
    private var emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 16)
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let category = selectedCategory {
            fetchSearchResultsByCategory(category)
        } else {
            fetchSearchResultsAll()
        }

        selectButton(allButton)
        setupButtonsStackView()
        setupButtonsAction()
        selectButton(allButton)
        setupReservationChartTableView()
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBarView)
        navigationBarView.addSubview(navigationTitleLabel)
        buttonScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(buttonScrollView)
        view.addSubview(lineView)
        view.addSubview(numLabel)
        view.addSubview(searchNumLabel)
        view.addSubview(sortButton)
        reservationChartTableView.backgroundColor = .white
        view.addSubview(reservationChartTableView)
        view.addSubview(emptyStateView)
        emptyStateView.isHidden = true
        
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBarView.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        navigationTitleLabel.snp.makeConstraints {make in
            make.centerY.equalTo(navigationBarView.snp.centerY)
            make.centerX.equalTo(navigationBarView.snp.centerX)
        }
        buttonScrollView.snp.makeConstraints {make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        lineView.snp.makeConstraints {make in
            make.top.equalTo(buttonScrollView.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
        sortButton.snp.makeConstraints {make in
            make.top.equalTo(lineView.snp.bottom).offset(17)
            make.trailing.equalToSuperview().offset(-24)
        }
        numLabel.snp.makeConstraints {make in
            make.centerY.equalTo(sortButton.snp.centerY)
            make.leading.equalToSuperview().offset(24)
        }
        searchNumLabel.snp.makeConstraints {make in
            make.centerY.equalTo(numLabel.snp.centerY)
            make.leading.equalTo(numLabel.snp.trailing)
        }
        reservationChartTableView.snp.makeConstraints {make in
            make.top.equalTo(sortButton.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
    }
    //MARK: -Action
    @objc func buttonTapped(_ sender: ModelReservationTypeButton) {
        selectButton(sender)

        guard let categoryTitle = sender.title(for: .normal) else { return }

        if categoryTitle == "전체" {
            fetchSearchResultsAll()
        } else {
            fetchSearchResultsByCategory(categoryTitle)
        }
    }
    
    private func setupButtonsAction() {
        let buttons = [
            allButton,
            specialButton,
            actorButton,
            interviewButton,
            dailyButton,
            studioButton,
            weddingButton,
            partyButton,
            etcButton
        ]
        buttons.forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }

    private func selectButton(_ button: ModelReservationTypeButton) {
        selectedButton?.backgroundColor = .white
        button.backgroundColor = .mainBold
        selectedButton?.isSelected = false
        button.isSelected = true
        selectedButton = button
    }
    
    @objc func sortButtonTapped() {
        let sortOptionsVC = SortOptionsViewController()
        sortOptionsVC.modalPresentationStyle = .custom
        sortOptionsVC.transitioningDelegate = self
        sortOptionsVC.onOptionSelected = { [weak self] selectedTitle in
            self?.sortButton.text = selectedTitle
            self?.selectedSortOption = selectedTitle
            self?.currentPage = 0
            self?.searchResults.removeAll()
            self?.reservationChartTableView.reloadData()
            
            if let category = self?.selectedCategory {
                self?.fetchSearchResultsByCategory(category)
            } else {
                self?.fetchSearchResultsAll()
            }
        }
        self.present(sortOptionsVC, animated: true)
    }
   
    
    //MARK: -Helpers
    private func mapSortParameter(from selectedSortOption: String) -> SearchSort? {
        switch selectedSortOption {
        case "리뷰 순":
            return .review
        case "가격 낮은 순":
            return .asc
        case "가격 높은 순":
            return .desc
        default:
            return nil
        }
    }
    
    private func mapCategoryNameToSearchCategory(_ name: String) -> SearchCategory? {
        switch name {
        case "전체":
            return nil
        case "데일리 메이크업":
            return .DAILY
        case "배우 메이크업":
            return .ACTOR
        case "면접 메이크업":
            return .INTERVIEW
        case "파티/이벤트 메이크업":
            return .PARTY
        case "웨딩 메이크업":
            return .WEDDING
        case "특수 메이크업":
            return .PROSTHETIC
        case "스튜디오 메이크업":
            return .STUDIO
        case "기타 메이크업":
            return .ETC
        default:
            return nil
        }
    }
    
    private func setupButtonsStackView() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 5
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillProportionally
        buttonScrollView.addSubview(buttonsStackView)
        [allButton, specialButton, actorButton, interviewButton, dailyButton, studioButton, weddingButton, partyButton, etcButton].forEach { button in
            buttonsStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.greaterThanOrEqualTo(54)
            }
        }

        buttonScrollView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(10)
        }
        buttonScrollView.contentSize = buttonsStackView.intrinsicContentSize
    }
    private func setupReservationChartTableView() {
        reservationChartTableView = UITableView()
        
        //delegate 연결
        reservationChartTableView.delegate = self
        reservationChartTableView.dataSource = self
        
        //cell 등록
        let ModelReservationChartTableViewCell = UINib(nibName: "ModelReservationChartTableViewCell", bundle: nil)
        reservationChartTableView.register(ModelReservationChartTableViewCell, forCellReuseIdentifier: "ModelReservationChartTableViewCell")
        
    }
}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ModelReservationChartViewController: UITableViewDataSource, UITableViewDelegate {
    //cell의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingEmptyState {
            return 0
        } else {
            return searchResults.count
        }
    }
    
    //cell의 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingEmptyState {
            return UITableViewCell()
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ModelReservationChartTableViewCell", for: indexPath) as? ModelReservationChartTableViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.selectionStyle = .none
            let data = searchResults[indexPath.row]
            cell.configure(with: data)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 141
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservationVC = ModelReservationViewController()
        let portfolioID = searchResults[indexPath.row].portfolioId
        reservationVC.portfolioID = portfolioID
        self.navigationController?.pushViewController(reservationVC, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension ModelReservationChartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        guard !isLastPage else {
            return
        }
        
        if offsetY + height >= contentHeight, !isLoading, !isShowingEmptyState, currentPage < totalPage {
            currentPage += 1
 
            if let category = selectedCategory {
                fetchSearchResultsByCategory(category)
            } else {
                fetchSearchResultsAll()
            }
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension ModelReservationChartViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ModelReservationChartViewController {
    //카테고리 검색
    func fetchSearchResultsByCategory(_ categoryName: String) {
        guard let searchCategory = mapCategoryNameToSearchCategory(categoryName),
                !isLoading else {
            return
        }
        
        isLoading = true
        let sortParameter = mapSortParameter(from: selectedSortOption)
        
        SearchManager.shared.getSearchCategory(category: searchCategory, page: currentPage, sort: sortParameter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let searchResultDTO):
                    self.handleSearchResults(searchResultDTO)
                case .failure(let error):
                    self.numLabel.text = "0"
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("카테고리 검색 실패: \(responseString ?? "no data")")
                    }
                    self.totalPage = 0
                    self.isShowingEmptyState = true
                    self.reservationChartTableView.reloadData()
                }
            }
        }
    }
    
    func fetchSearchResultsAll() {
        guard !isLoading else { return }
        isLoading = true
        let sortParameter = mapSortParameter(from: selectedSortOption)
        
        SearchManager.shared.getSearchAll(page: currentPage, sort: sortParameter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let searchResultDTO):
                    print(searchResultDTO)
                    self.handleSearchResults(searchResultDTO)
                case .failure(let error):
                    self.numLabel.text = "0"
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("전체 조회 실패: \(responseString ?? "no data")")
                    }
                    self.totalPage = 0
                    self.isShowingEmptyState = true
                    self.reservationChartTableView.reloadData()
                }
            }
        }
    }
    
    private func handleSearchResults(_ searchResultDTO: SearchResultDTO) {
        searchResults.removeAll()
        
        if let totalNumber = searchResultDTO.data?.totalNumber {
            self.numLabel.text = "\(totalNumber)"
        } else {
            self.numLabel.text = "0"
        }
        
        if let content = searchResultDTO.data?.content, !content.isEmpty {
            isShowingEmptyState = false
            searchResults.append(contentsOf: content)
            reservationChartTableView.reloadData()
            emptyStateView.isHidden = true
        } else {
            emptyStateView.isHidden = false
        }
        
        totalPage = searchResultDTO.data?.totalPage ?? 0
    }
}

