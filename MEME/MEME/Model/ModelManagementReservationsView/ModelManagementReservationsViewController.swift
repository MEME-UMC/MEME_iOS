//
//  ModelManagementReservationsViewController.swift
//  MEME
//
//  Created by 정민지 on 1/23/24.
//

import UIKit
import SnapKit

struct ReservationSection {
    let date: Date
    var reservations: [ReservationData]
}

final class ModelManagementReservationsViewController: UIViewController {
    // MARK: - Properties
    private var reservationSections: [ReservationSection] = []
    private var collectionViewItems: [ReservationCollectionViewItem] = []
    
    private var reservationCollectionView: UICollectionView!
    private let navigationBar = NavigationBarView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.delegate = self
        navigationBar.configure(title: "전체 예약 보기")
        
        showModelReservations()
        setupReservationCollectionView()
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        reservationCollectionView.backgroundColor = .white
        view.addSubview(reservationCollectionView)
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBar.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        reservationCollectionView.snp.makeConstraints {make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    //MARK: -Helpers
    enum ReservationCollectionViewItem {
        case date(Date)
        case reservation(ReservationData)
    }
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
    }
    
    private func setupCollectionViewItems() {
        collectionViewItems = reservationSections.flatMap { section -> [ReservationCollectionViewItem] in

            var sectionItems: [ReservationCollectionViewItem] = [.date(section.date)]

            sectionItems += section.reservations.map { .reservation($0) }
            return sectionItems
        }
    }
    private func setupReservationCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        reservationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //delegate 연결
        reservationCollectionView.delegate = self
        reservationCollectionView.dataSource = self
        
        //cell 등록
        reservationCollectionView.register(ModelManagementReservationsDateCollectionViewCell.self, forCellWithReuseIdentifier: ModelManagementReservationsDateCollectionViewCell.identifier)

  
        reservationCollectionView.register(UINib(nibName: "ModelReservationConfirmViewCell", bundle: nil), forCellWithReuseIdentifier: ModelReservationConfirmViewCell.identifier)
        
    }
}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ModelManagementReservationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    //cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItems.count
    }
    
    //cell의 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionViewItems[indexPath.item]
        switch item {
        case .date(let date):
            guard let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelManagementReservationsDateCollectionViewCell.identifier, for: indexPath) as? ModelManagementReservationsDateCollectionViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            dateCell.configure(with: date)
            return dateCell
            
        case .reservation(let reservation):
            guard let reservationCell = collectionView.dequeueReusableCell(withReuseIdentifier: ModelReservationConfirmViewCell.identifier, for: indexPath) as? ModelReservationConfirmViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            reservationCell.contentView.backgroundColor = .gray200
            reservationCell.modelReservationLabel.textColor = .black
            reservationCell.modelReservationMakeupNameLabel.textColor = .black
            reservationCell.modelReservationArtistNameLabel.textColor = .black
            reservationCell.modelReservationLocationLabel.textColor = .black
            reservationCell.modelReservationPriceLabel.textColor = .black
            reservationCell.configure(with: reservation)
            return reservationCell
        }
    }
}

extension ModelManagementReservationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionViewItems[indexPath.item] {
        case .date:
            return CGSize(width: collectionView.frame.width, height: 20)
        case .reservation:
            return CGSize(width: collectionView.frame.width, height: 142)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12)
    }
}

// MARK: -BackButtonTappedDelegate
extension ModelManagementReservationsViewController: BackButtonTappedDelegate  {
    func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}

//MARK: -API 통신 메소드
extension ModelManagementReservationsViewController {
    func showModelReservations() {
        ReservationManager.shared.getModelReservation(modelId: 6) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservationResponse):
                    self?.groupReservationsByDate(reservationResponse.data ?? [])
                    self?.reservationCollectionView.reloadData()
                    print("모델 예약 정보 조회 성공: \(reservationResponse)")
                    
                case .failure(let error):
                    print("모델 예약 정보 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    private var isoDateFormatter: ISO8601DateFormatter {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }

    private func groupReservationsByDate(_ reservations: [ReservationData]) {
        let groupedDictionary = Dictionary(grouping: reservations) { (reservationData) -> Date in
            guard let date = isoDateFormatter.date(from: reservationData.reservationDate) else {
                return Date()
            }
            
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            return Calendar.current.date(from: components) ?? date
        }
        
        reservationSections = groupedDictionary.map { (key, value) in
            ReservationSection(date: key, reservations: value)
        }.sorted(by: { $0.date < $1.date })
        
        setupCollectionViewItems()
    }
}
