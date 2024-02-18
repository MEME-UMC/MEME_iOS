//
//  SetBusinessInfoDetailViewController.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit

final class SetBusinessInfoDetailViewController: UIViewController {
    typealias TimeCell = TimeCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<TimeSection, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<TimeSection, String>
    typealias HeaderView = TimeHeaderSupplementaryView
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private var fieldButtons: [UIButton]!
    
    @IBOutlet private var locationButtons: [UIButton]!
    @IBOutlet private var locationCheckImages: [UIImageView]!
    
    @IBOutlet private weak var textField: UITextField!
    
    @IBOutlet var timeViews: [UIView]!
    
    @IBOutlet private var weekButtons: [UIButton]!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private var timeSetButtons: [UIButton]!
    
    private var dataSource: DataSource?
    private var snapShot: SnapShot?
    
    private var selectedFields: Set<Int> = []
    private var selectedWeekDay: Set<Int> = []
    private var startTime: String?
    private var endTime: String?
    private var isStart = true
    private var builder: ArtistProfileInfoBuilder?
    private var selectedLocation: MakeUpLocation?
    private var selectedExperience: WorkExperience?
    
    private let amTimes: [String] = [
        "04:00", "04:30",
        "05:00", "05:30",
        "06:00", "06:30",
        "07:00", "07:30",
        "08:00", "08:30",
        "09:00", "09:30",
        "10:00", "10:30",
        "11:00", "11:30"
    ]
    
    private let pmTimes: [String] = [
        "12:00", "12:30",
        "13:00", "13:30",
        "14:00", "14:30",
        "15:00", "15:30",
        "16:00", "16:30",
        "17:00", "17:30",
        "18:00", "18:30",
        "19:00", "19:30",
        "20:00", "20:30",
        "21:00"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureCollectionView()
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필 관리")
        progressBar.configure(progress: 2)
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        
        fieldButtons.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.mainBold.cgColor
        }
        
        locationButtons.forEach { button in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray300.cgColor
            button.layer.cornerRadius = 9
        }
        
        textField.layer.cornerRadius = 9
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray300.cgColor
        
        timeViews.forEach {
            $0.layer.cornerRadius = 9
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
        }
        
        weekButtons.forEach { button in
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.mainBold.cgColor
        }

        completeButton.layer.cornerRadius = 10
    }
    
    func configure(builder: ArtistProfileInfoBuilder) {
        self.builder = builder
    }
    
    private func setNextButton() {
        guard
            !selectedFields.isEmpty,
            selectedLocation != nil,
            !selectedWeekDay.isEmpty,
            startTime != nil,
            endTime != nil
        else {
            completeButton.isEnabled = false
            return
        }
        
        completeButton.isEnabled = true
    }
    
    @IBAction func fieldButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        if selectedFields.contains(tag) {
            selectedFields.remove(tag)
            sender.tintColor = .black
            sender.backgroundColor = .white
        } else {
            selectedFields.insert(tag)
            sender.tintColor = .white
            sender.backgroundColor = .mainBold
        }
    }
    
    @IBAction func makeUpLocationButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        locationButtons.forEach { button in
            if button.tag == tag {
                button.layer.borderColor = UIColor.mainBold.cgColor
                locationCheckImages[button.tag].image = .icCheck
                
            } else {
                button.layer.borderColor = UIColor.gray300.cgColor
                locationCheckImages[button.tag].image = nil
            }
        }
        
        switch sender.tag {
        case 0:
            selectedLocation = .SHOP
        case 1:
            selectedLocation = .VISIT
        default:
            selectedLocation = .BOTH
        }
        
        if selectedLocation == .VISIT {
            textField.text = nil
            textField.isEnabled = false
        } else {
            textField.isEnabled = true
        }
    }
    
    @IBAction func weekButtonTapped(_ sender: UIButton) {
        if selectedWeekDay.contains(sender.tag) {
            selectedWeekDay.remove(sender.tag)
            weekButtons[sender.tag].tintColor = .black
            weekButtons[sender.tag].backgroundColor = .white
        } else {
            selectedWeekDay.insert(sender.tag)
            weekButtons[sender.tag].tintColor = .white
            weekButtons[sender.tag].backgroundColor = .mainBold
        }
    }
    
    @IBAction private func timeButtonTapped(_ sender: UIButton) {
        if sender.tag == TimeSection.am.rawValue {
            isStart = true
        } else {
            isStart = false
        }
        
        timeSetButtons.forEach {
            $0.isEnabled = false
        }
        collectionView.isHidden = false
    }

    @IBAction private func completionButtonTapped(_ sender: Any) {
        guard 
            var builder = builder,
            let selectedLocation = selectedLocation,
            let startTime = startTime,
            let endTime = endTime
        else { return }
        
        var specialization: [String] = []
        MakeUpCategory.allCases.forEach { category in
            if selectedFields.contains(category.intVal) {
                specialization.append(category.rawValue)
            }
        }
        
        var weekDays: [String] = []
        DayOfWeek.allCases.forEach { day in
            if selectedWeekDay.contains(day.intVal) {
                weekDays.append(day.rawValue)
            }
        }
        
        builder = builder.specialization(specialization)
        builder = builder.makeupLocation(selectedLocation.rawValue)
        builder = builder.week(weekDays)
        builder = builder.startTime(startTime)
        builder = builder.endTime(startTime)
        if
            selectedLocation != .VISIT,
            let text = textField.text
        {
            builder = builder.shopLocation(text)
        }
        
        let nextVC = ArtistTabBarController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - collectionView 설정
extension SetBusinessInfoDetailViewController {
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        configureDataSource()
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TimeCell, String> { cell, indexPath, itemIdentifier in
            cell.configure(time: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TimeHeaderSupplementaryView>(elementKind: HeaderView.className) { supplementaryView, elementKind, indexPath in
            switch indexPath.section {
            case TimeSection.am.rawValue:
                supplementaryView.setTitle(title: TimeSection.am.getStringValue())
            default:
                supplementaryView.setTitle(title: TimeSection.pm.getStringValue())
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        dataSource?.supplementaryViewProvider = { view, kind, index in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: index
            )
        }

        snapShot = SnapShot()
        snapShot?.appendSections([.am, .pm])
        snapShot?.appendItems(amTimes, toSection: .am)
        snapShot?.appendItems(pmTimes, toSection: .pm)
        dataSource?.apply(snapShot ?? SnapShot(), animatingDifferences: false)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(55),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(0),
                trailing: .fixed(6),
                bottom: .fixed(0)
            )
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(31)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 5
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 14, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: 10,
                trailing: 0
            )
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(17)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: HeaderView.className,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        return layout
    }
}

extension SetBusinessInfoDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeCell else { return }
        cell.contentView.layer.borderColor = UIColor.mainBold.cgColor
        
        if isStart {
            startTime = cell.getTime()
            startTimeLabel.text = cell.getTime()
        } else {
            endTime = cell.getTime()
            endTimeLabel.text = cell.getTime()
        }
        
        timeSetButtons.forEach {
            $0.isEnabled = true
        }
        collectionView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeCell else { return }
        cell.contentView.layer.borderColor = UIColor.gray300.cgColor
    }
}

// MARK: - scrollView delelgate
extension SetBusinessInfoDetailViewController: UIScrollViewDelegate {
    
}

extension SetBusinessInfoDetailViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
