//
//  ArtistPortfolioEditingViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/28/24.
//

import UIKit

final class ArtistPortfolioEditingViewController: UIViewController, UINavigationControllerDelegate {
    var pastIndex: IndexPath?

    @IBOutlet private var makeupCategoryCollectionView: UICollectionView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imagePickerStackView: UIStackView!
    
    @IBOutlet private weak var firstImgView: UIImageView!
    @IBOutlet private weak var secondImgView: UIImageView!
    @IBOutlet private weak var thirdImgView: UIImageView!
    
    
    @IBOutlet private weak var trashButton: UIButton!
    @IBOutlet private weak var firstDeleteButton: UIButton!
    @IBOutlet private weak var secondDeleteButton: UIButton!
    @IBOutlet private weak var thirdDeleteButton: UIButton!
    
    @IBOutlet private weak var makeupNameTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var infoTextField: UITextField!
    
    
    private var userId = 1
    private var artistId = 3
    private var selectedCategory: PortfolioCategories?
    
    private var buttonAt: Int = 0
    private var imgCnt: Int = 0
    private var isEdit: Bool = portfolioIdx == -1 ? false : true
    
    private lazy var imgViewList: [UIImageView] = {
        return [self.firstImgView, self.secondImgView, self.thirdImgView]
    }()
    
    private lazy var artistProfileEditingInfoBar: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit {
            getPortfolio()
        }
        configureSubviews()
        makeConstraints()
        collectionViewConfigure()
        uiSet()
    }
    
    private func getPortfolio() {
        // 민지님 코드
    }
    
    private func createPortfolio() {
        let createPortfolio = PortfolioManager.shared
        createPortfolio.createPortfolio(
            artistId: artistId,
            category: selectedCategory!,
            makeup_name: makeupNameTextField.text!,
            price: Int(priceTextField.text!)!,
            info: infoTextField.text!,
            portfolio_img_src: ["dsfjkfs","sdfjsdsdk"]
        ) { result in
            switch result {
            case .success(let data):
                print(data.message)
                portfolioIdArray.append(data.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func uiSet(){
        self.tabBarController?.tabBar.isHidden = true
        priceTextField.keyboardType = .numberPad
        if isEdit {
            titleLabel.text = "포트폴리오 수정"
            artistProfileEditingInfoBar.setTitle("수정하기", for: .normal)
        }else {
            titleLabel.text = "포트폴리오 추가"
            artistProfileEditingInfoBar.setTitle("추가하기", for: .normal)
            trashButton.isHidden = true
        }
        deleteButtonAppear()
    }
    
    private func collectionViewConfigure(){
        makeupCategoryCollectionView.delegate = self
        makeupCategoryCollectionView.dataSource = self
        makeupCategoryCollectionView.register(UINib(nibName: "ArtistMakeupTagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistMakeupTagCollectionViewCell")
        
    }
    
    private func configureSubviews() {
        view.addSubview(artistProfileEditingInfoBar)
    }
    private func makeConstraints() {
        artistProfileEditingInfoBar.snp.makeConstraints {make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.height.equalTo(49)
        }
    }
    
    private func deleteButtonAppear() {
        if self.imgCnt==3 {
            firstDeleteButton.isHidden = false
            secondDeleteButton.isHidden = false
            thirdDeleteButton.isHidden = false
        }else if self.imgCnt==2 {
            firstDeleteButton.isHidden = true
            secondDeleteButton.isHidden = false
            thirdDeleteButton.isHidden = false
        }else if self.imgCnt==1 {
            firstDeleteButton.isHidden = true
            secondDeleteButton.isHidden = false
            thirdDeleteButton.isHidden = true
        }else {
            firstDeleteButton.isHidden = true
            secondDeleteButton.isHidden = true
            thirdDeleteButton.isHidden = true
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        var title = ""
        var message = ""
        
        if isEdit {
            title = "포트폴리오 수정하기"
            message = "\n포트폴리오 수정을 취소하시겠습니까?"
        } else {
            title = "포트폴리오 등록하기"
            message = "\n포트폴리오 등록을 취소하시겠습니까?"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func editButtonDidTap(_ sender: UIButton) {
        print("hi")
        let okCreateAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
                self?.createPortfolio()
                self?.navigationController?.popViewController(animated: true)
        }
        let okEditAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
//                self?.editPortfolio()
                self?.navigationController?.popViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        var title = ""
        var message = ""
        
        if isEdit {
            title = "포트폴리오 수정하기"
            message = "\n포트폴리오를 수정하시겠습니까?"
        } else {
            title = "포트폴리오 등록하기"
            message = "\n포트폴리오를 등록하시겠습니까?"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // HIG에 따라 Cancel이 왼쪽
        if isEdit{
            alert.addAction(okCreateAction)
        }else {
            alert.addAction(okEditAction)
        }
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func trashButtonDidTap(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "포트폴리오 삭제하기", message: "\n포트폴리오를 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler : nil )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func pick(_ sender: UIButton) {
            // 이미지 피커 컨트롤러 생성
            buttonAt = sender.tag
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary // 이미지 소스로 사진 라이브러리 선택
            picker.allowsEditing = true // 이미지 편집 기능 On
            // 델리게이트 지정
            picker.delegate = self
            
            // 이미지 피커 컨트롤러 실행
            self.present(picker, animated: false)
        }
    @IBAction func deleteImg(_ sender: UIButton) {
        buttonAt = sender.tag
        if buttonAt==0 {
            imgViewList[0].image = .icPicture
        }else if buttonAt==1 {
            if imgCnt==1 {
                imgViewList[buttonAt].image = nil
                imgViewList[0].image = .icPicture
            }else if imgCnt==2 {
                imgViewList[buttonAt].image = imgViewList[buttonAt+1].image
                imgViewList[buttonAt+1].image = nil
                imgViewList[0].image = .icPicture
            }else {
                imgViewList[buttonAt].image = imgViewList[buttonAt-1].image
                imgViewList[0].image = .icPicture
            }
        }else{
            if imgCnt==3 {
                imgViewList[buttonAt].image = imgViewList[buttonAt-1].image
                imgViewList[buttonAt-1].image = imgViewList[buttonAt-2].image
                imgViewList[0].image = .icPicture
            }else {
                imgViewList[buttonAt].image = nil
            }
        }
        imgCnt-=1
        print("deleted buttonat:"+String(self.buttonAt)+", imgCnt:"+String(self.imgCnt))
        deleteButtonAppear()
    }
}

extension ArtistPortfolioEditingViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolioDummies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistMakeupTagCollectionViewCell", for: indexPath) as? ArtistMakeupTagCollectionViewCell else { return UICollectionViewCell() }
        cell.makeupTagLabel.text = portfolioDummies[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 indexPath에 대한 셀을 가져오기
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ArtistMakeupTagCollectionViewCell {
            // 선택된 셀에 대한 작업 수행
            selectedCell.selected()
            selectedCategory = portfolioDummies[indexPath.row].category
        }
        
        // 나머지 indexPath에 대한 셀을 가져와서 작업 수행
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
            if visibleIndexPath != indexPath,
               let deselectedCell = collectionView.cellForItem(at: visibleIndexPath) as? ArtistMakeupTagCollectionViewCell {
                // 선택되지 않은 셀에 대한 작업 수행
                deselectedCell.deSelected()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 97
        if indexPath.row == 3 {
            width += 23
        }else if indexPath.row == 6 {
            width += 8
        }else if indexPath.row == 7 {
            width += 38
        }
        return CGSize(width : width, height: 27)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
}

extension ArtistPortfolioEditingViewController : UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 이미지 피커 컨트롤러 창 닫기
            print("이미지 선택하지않고 취소한 경우")
            self.dismiss(animated: false) { () in
                // 알림 창 호출
                let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false)
            }
        }
        // 이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 이미지 피커 컨트롤러 창 닫기
            picker.dismiss(animated: false) { () in
                // 이미지를 이미지 뷰에 표시
                let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                
                
                if self.buttonAt == 0 {
                    if self.imgCnt == 0 {
                        self.imgViewList[1].image = img
                        self.imgCnt+=1
                    }else if self.imgCnt == 1 {
                        self.imgViewList[2].image = self.imgViewList[1].image
                        self.imgViewList[1].image = img
                        self.imgCnt+=1
                    }else if self.imgCnt == 2 {
                        self.imgViewList[0].image = img
                        self.imgCnt+=1
                    }else {
                        self.firstImgView.image = img
                    }
                }else{
                    if self.buttonAt == 0 {
                        self.firstImgView.image = img
                    }else if self.buttonAt == 1 {
                        self.secondImgView.image = img
                    }else {
                        self.thirdImgView.image = img
                    }
                }
                print("buttonat:"+String(self.buttonAt)+", imgCnt:"+String(self.imgCnt))
                self.deleteButtonAppear()
            }
        }
}
