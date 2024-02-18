//
//  ArtistHeaderView.swift
//  MEME
//
//  Created by 임아영 on 2/3/24.
//

import UIKit

class ArtistHeaderView: UIView {
        
    weak var delegate: ArtistHeaderViewDelegate?

        // MARK: - Properties
        
        let profileImage: UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage.profile
            iv.layer.cornerRadius = 94 / 2
            iv.clipsToBounds = true
           
            return iv
        }()
        
        let namebutton: UIButton = {
            let button = UIButton()
            button.setTitle("차차", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)

            return button
        }()

        let vectorbutton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage.icRightArrow, for: .normal)
            button.tintColor = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 1)
            button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)

            return button
        }()
        
        let myPageIcon1: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage.userCheck, for: .normal)
            button.tintColor = UIColor.mainBold
            button.addTarget(self, action: #selector(myProfileManageClicked(sender:)), for: .touchUpInside)

            return button
        }()

        let myPageIcon2: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage.bookOpen, for: .normal)
            button.tintColor = UIColor.mainBold
            button.addTarget(self, action: #selector(myPortfolioClicked(sender:)), for: .touchUpInside)

            return button
        }()

        let myPageIcon3: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage.reserve, for: .normal)
            button.tintColor = UIColor.mainBold
            button.addTarget(self, action: #selector(myReservationManageClicked(sender:)), for: .touchUpInside)

            return button
        }()

        lazy var mpArtistlabel: UILabel = {
            let label = UILabel()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myProfileManageClicked(sender:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
                
            return label
        }()
        
        lazy var mpMakeuplabel: UILabel = {
            let label = UILabel()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myPortfolioClicked(sender:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
                
            return label
        }()
        
        lazy var mpReviewlabel: UILabel = {
            let label = UILabel()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myReservationManageClicked(sender:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
                
            return label
        }()
        
        let lineView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray500

            return view
        }()
        
        // MARK: - Lifecycle
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            configureUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Helpers
        
        func configureUI() {
            
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            namebutton.translatesAutoresizingMaskIntoConstraints = false
            vectorbutton.translatesAutoresizingMaskIntoConstraints = false
            myPageIcon1.translatesAutoresizingMaskIntoConstraints = false
            myPageIcon2.translatesAutoresizingMaskIntoConstraints = false
            myPageIcon3.translatesAutoresizingMaskIntoConstraints = false
            mpArtistlabel.translatesAutoresizingMaskIntoConstraints = false
            mpMakeuplabel.translatesAutoresizingMaskIntoConstraints = false
            mpReviewlabel.translatesAutoresizingMaskIntoConstraints = false
            lineView.translatesAutoresizingMaskIntoConstraints = false

            addSubview(profileImage)
            NSLayoutConstraint.activate([
                profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
                profileImage.widthAnchor.constraint(equalToConstant: 94),
                profileImage.heightAnchor.constraint(equalToConstant: 94),
                profileImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
            ])
            
            addSubview(namebutton)
            namebutton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18)
            NSLayoutConstraint.activate([
                namebutton.centerXAnchor.constraint(equalTo: centerXAnchor),
                namebutton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 33)
            ])
            
            addSubview(vectorbutton)
            NSLayoutConstraint.activate([
                vectorbutton.leadingAnchor.constraint(equalTo: namebutton.trailingAnchor, constant: 11),
                vectorbutton.centerYAnchor.constraint(equalTo: namebutton.centerYAnchor),
                vectorbutton.widthAnchor.constraint(equalToConstant: 5.9),
                vectorbutton.heightAnchor.constraint(equalToConstant: 11.92)
            ])
            
            addSubview(myPageIcon1)
            NSLayoutConstraint.activate([
                myPageIcon1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 63),
                myPageIcon1.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 207),
                myPageIcon1.widthAnchor.constraint(equalToConstant: 24),
                myPageIcon1.heightAnchor.constraint(equalToConstant: 24)
            ])

            addSubview(myPageIcon2)
            NSLayoutConstraint.activate([
                myPageIcon2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                myPageIcon2.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 207),
                myPageIcon2.widthAnchor.constraint(equalToConstant: 20.9),
                myPageIcon2.heightAnchor.constraint(equalToConstant: 17)
            ])
            
            addSubview(myPageIcon3)
            NSLayoutConstraint.activate([
                myPageIcon3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -63),
                myPageIcon3.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 207),
                myPageIcon3.widthAnchor.constraint(equalToConstant: 20),
                myPageIcon3.heightAnchor.constraint(equalToConstant: 20)
            ])
            
            addSubview(mpArtistlabel)
            mpArtistlabel.text = "프로필 관리"
            mpArtistlabel.font = UIFont(name: "Pretendard-Regular", size: 12)
            
            addSubview(mpMakeuplabel)
            mpMakeuplabel.text = "포트폴리오 관리"
            mpMakeuplabel.font = UIFont(name: "Pretendard-Regular", size: 12)
            
            addSubview(mpReviewlabel)
            mpReviewlabel.text = "예약 관리"
            mpReviewlabel.font = UIFont(name: "Pretendard-Regular", size: 12)
            
            NSLayoutConstraint.activate([
                mpArtistlabel.bottomAnchor.constraint(equalTo:bottomAnchor, constant: -18),
                mpArtistlabel.centerXAnchor.constraint(equalTo: myPageIcon1.centerXAnchor),
                
                mpMakeuplabel.topAnchor.constraint(equalTo: myPageIcon2.bottomAnchor, constant: 10),
                mpMakeuplabel.centerXAnchor.constraint(equalTo: myPageIcon2.centerXAnchor),

                mpReviewlabel.topAnchor.constraint(equalTo: myPageIcon3.bottomAnchor, constant: 10),
                mpReviewlabel.centerXAnchor.constraint(equalTo: myPageIcon3.centerXAnchor)
            ])
           
            addSubview(lineView)
            NSLayoutConstraint.activate([
                lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
                lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -29),
                lineView.topAnchor.constraint(equalTo: mpArtistlabel.bottomAnchor, constant: 21),
                lineView.heightAnchor.constraint(equalToConstant: 1)
            ])

        }

    @objc func buttonClicked(sender: UIView ) {
        delegate?.buttonClicked()
        }
        
    @objc func myProfileManageClicked(sender: UIView) {
            delegate?.artistProfileManageClicked()
        }
    @objc func myPortfolioClicked(sender: UIView) {
            delegate?.portfolioManageClicked()
        }
    @objc func myReservationManageClicked(sender: UIView) {
            delegate?.artistReservationManageClicked()
        }
    }

protocol ArtistHeaderViewDelegate: AnyObject {
    func buttonClicked()
    func artistProfileManageClicked()
    func portfolioManageClicked()
    func artistReservationManageClicked()
}
