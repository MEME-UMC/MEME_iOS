//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

final class ArtistHomeViewController: UIViewController {
    @IBOutlet private var artistHomeProfileStatusView: UIView!
    @IBOutlet private var secondArtistHomeProfileStatusView: UIView!
    @IBOutlet private var artistProfileImageView: UIImageView!
    @IBOutlet private var artistHomeProfileLabel: UILabel!
    @IBOutlet private var artistReservationStatusTableView: UITableView!
    @IBOutlet private weak var firstArtistResLabel: UILabel!
    @IBOutlet private weak var firstArtistResTimeLabel: UILabel!
    @IBOutlet private weak var firstArtistResBtnLabel: UILabel!
    @IBOutlet private weak var secondArtistResBtn: UIButton!
    @IBOutlet weak var secondArtistResLabel: UILabel!
    @IBOutlet weak var secondArtistTimeLabel: UILabel!
    
    private var artistNickName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        uiSet()
        tableViewConfigure()
    }
    private func uiSet(){
        self.tabBarController?.tabBar.isHidden = false
        if TodayRes == 0 {
            firstArtistResLabel.text = "포트폴리오 관리하러 가기"
            firstArtistResBtnLabel.text = ">"
            firstArtistResTimeLabel.text = nil
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else if TodayRes == 1 {
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }
        artistHomeProfileStatusView.layer.cornerRadius = 10
        secondArtistHomeProfileStatusView.layer.cornerRadius = 10
        
        artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.height/2
        artistProfileImageView.clipsToBounds = true
        
        artistHomeProfileLabel.text = "안녕하세요, " + String(artistNickName) + "님!\n내일 예약 " + String(tomorrowRes) + "건이 있어요."
    }
    
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }

    @IBAction private func profileImageTapped(_ sender: UIButton) {
        let vc = ModelViewArtistProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func entireReservationBtnTapped(_ sender: UIButton) {
        let vc = EntireArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func reservationManagedBtnTapped(){
        let vc = SingleArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func firstTodayResBtnDidTap(_ sender: UIButton) {
        if(TodayRes != 0) {
            let vc = SingleArtistReservationManageViewController()
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ArtistPortfolioManageViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction private func secondTodayResBtnDidTap(_ sender: UIButton) {
        let vc = SingleArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArtistHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resMakeUpNameArray.count>2 {
            return 2
        } else {
            return resMakeUpNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        let reservation = ReservationData(resMakeupName: resMakeUpNameArray[indexPath.row], resDate: resDateArray[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(192)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SingleArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
extension ArtistHomeViewController : ArtistReservationCellDelegate {
    func cellTapped() {
        let vc = SingleArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
