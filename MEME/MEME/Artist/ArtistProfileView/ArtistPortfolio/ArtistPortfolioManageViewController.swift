//
//  ArtistPortfolioManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/27/24.
//

import UIKit

final class ArtistPortfolioManageViewController: UIViewController {
    
    @IBOutlet private var portfolioCollectionView: UICollectionView!
    @IBOutlet private var noPortfolioLabel: UIStackView!
    
    // 더미데이터
    private var portfolioData : PortfolioData?
    private var artistId : Int = 10
    private var page : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        print("viewWillAppear 실행됨")
        getAllPortfolio()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        collectionViewConfig()
    }
    
    private func getAllPortfolio() {
        let getAllPortfolio = PortfolioManager.shared
        getAllPortfolio.getAllPortfolio(artistId: artistId, page: page) { [weak self] result in
            switch result{
                case .success(let response):
                    self?.portfolioData = response.data
//                    print(response.data)
                    self?.portfolioCollectionView.reloadData()
                    self?.noPortfolioLabel.isHidden = !(self?.portfolioData?.content!.isEmpty)!
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func uiSet(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    private func collectionViewConfig(){
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        portfolioCollectionView.register(UINib(nibName: ArtistPortfolioCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ArtistPortfolioCollectionViewCell.className)
    }
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    @IBAction func portfolioAddButtonDidTap(_ sender: UIButton) {
        portfolioIdx = -1
        let vc = ArtistPortfolioEditingViewController(receivedData: portfolioIdx)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArtistPortfolioManageViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { if let portfolioData = portfolioData {
            return portfolioData.content!.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistPortfolioCollectionViewCell.className, for: indexPath) as? ArtistPortfolioCollectionViewCell
            else { return UICollectionViewCell() }
            if let portfolioData = portfolioData {
                cell.portfolioMainLabel.text = portfolioData.content?[indexPath.row].makeupName
                cell.portfolioSubLabel.text = portfolioData.content?[indexPath.row].category
                cell.portfolioPriceLabel.text = String(portfolioData.content![indexPath.row].price) + "원"
//                cell.portfolioImageView.image = UIImage(named: 
//                portfolioImageArray[indexPath.row]) // 수정 필요
            }
            return cell
        }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        portfolioIdx = indexPath.row
        let vc = ArtistPortfolioEditingViewController(
            receivedData: Int((self.portfolioData?.content![portfolioIdx].portfolioId)!)
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
