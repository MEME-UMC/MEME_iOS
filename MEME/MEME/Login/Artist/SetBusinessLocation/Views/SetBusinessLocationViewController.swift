//
//  SetBusinessLocationViewController.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit

final class SetBusinessLocationViewController: UIViewController {
    typealias LocationCell = BusinessLocationCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Region>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, Region>
    
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    private var dataSource: DataSource?
    private var snapShot: SnapShot?
    private var location: [Region] = Region.allCases
    private var selectedLocation: Set<Region> = []
    private var builder: ArtistProfileInfoBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureCollectionView()
        nextButton.layer.cornerRadius = 10
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필 입력")
        progressBar.configure(progress: 1)
        nextButton.layer.cornerRadius = 10
        setNextButton()
    }
    
    func configure(builder: ArtistProfileInfoBuilder) {
        self.builder = builder
    }
    
    func setNextButton() {
        if selectedLocation.isEmpty {
            nextButton.backgroundColor = .gray300
            nextButton.isEnabled = false
        } else {
            nextButton.backgroundColor = .mainBold
            nextButton.isEnabled = true
        }
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        let nextVC = SetBusinessInfoDetailViewController()
        let regions = Array(selectedLocation).map{ $0.rawValue }
        builder = builder?.region(regions)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension SetBusinessLocationViewController {
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        configureDataSource()
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<LocationCell, Region> { cell, indexPath, itemIdentifier in
            cell.configure(location: itemIdentifier.koreanName)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        snapShot = SnapShot()
        snapShot?.appendSections([0])
        snapShot?.appendItems(location, toSection: 0)
        dataSource?.apply(snapShot ?? SnapShot(), animatingDifferences: false)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.33),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(76)
            )
    
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 3
            )
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(6),
                trailing: .fixed(0),
                bottom: .fixed(6)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}

extension SetBusinessLocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LocationCell else { return }
        if selectedLocation.contains(location[indexPath.row]) {
            selectedLocation.remove(location[indexPath.row])
            cell.setColor(isSelected: false)
        } else {
            selectedLocation.insert(location[indexPath.row])
            cell.setColor(isSelected: true)
        }
        
        setNextButton()
    }
}

extension SetBusinessLocationViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
