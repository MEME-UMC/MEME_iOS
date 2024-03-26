//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

class ArtistHomeViewController: UIViewController {
    //UI Properites
    @IBOutlet private var artistHomeProfileStatusView: UIView!
    @IBOutlet private var secondArtistHomeProfileStatusView: UIView!
    @IBOutlet private var artistProfileImageView: UIImageView!
    @IBOutlet private var artistHomeProfileLabel: UILabel!
    @IBOutlet private var artistReservationStatusTableView: UITableView!
    @IBOutlet weak var firstArtistResLabel: UILabel!
    @IBOutlet weak var firstArtistResTimeLabel: UILabel!
    @IBOutlet weak var firstArtistResBtnLabel: UILabel!
    @IBOutlet weak var secondArtistResBtn: UIButton!
    @IBOutlet weak var secondArtistResLabel: UILabel!
    @IBOutlet weak var secondArtistResTimeLabel: UILabel!
    
    //Properties
    private var artistId: Int = 2
    private var todayCount: Int = 0
    private var tomorrowCount: Int = 0
    private var fromTomorrowCount: Int = 0
    private var selectedIdx: Int!
    private var reservationData: [ReservationData]!
    private var artistProfileData: ArtistProfileData?
    private var reservationStatusData: [Int] = []
    private var showReservationData: [Int] = [0,0,0,0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArtistProfile(userId: 1, artistId: artistId)
        getArtistReservation(artistId: artistId)
        tableViewConfigure()
    }
    private func uiSet(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if(todayCount == 0){
            firstArtistResLabel.text = "포트폴리오 관리하러 가기"
            firstArtistResBtnLabel.text = ">"
            firstArtistResTimeLabel.text = nil
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else if(todayCount == 1){
            firstArtistResLabel.text = reservationData[showReservationData[0]].makeupName
            firstArtistResTimeLabel.text = formatDateString(op:3, reservationData[showReservationData[0]].reservationDate)
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else{
            firstArtistResLabel.text = reservationData[showReservationData[0]].makeupName
            firstArtistResTimeLabel.text = formatDateString(op:3, reservationData[showReservationData[0]].reservationDate)
            secondArtistResLabel.text = reservationData[showReservationData[1]].makeupName
            secondArtistResTimeLabel.text = formatDateString(op:3, reservationData[showReservationData[1]].reservationDate)
        }
        artistHomeProfileStatusView.layer.cornerRadius = 10
        secondArtistHomeProfileStatusView.layer.cornerRadius = 10
        
        artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.height/2
        artistProfileImageView.clipsToBounds = true
        if let nickname = artistProfileData?.nickname {
            artistHomeProfileLabel.text = "안녕하세요, \(nickname)님!\n내일 예약 \(String(self.tomorrowCount))건이 있어요."
        }
        if let profileImg = artistProfileData?.profileImg {
//            FirebaseStorageManager.downloadImage(urlString: profileImg) { [weak self] image in
//                guard let image = image else { return } // 성공적으로 업로드 했으면 이미지가 nil 값이 아님
//                //이미지를 가지고 할 작업 처리 ex) 이미지 뷰에 다운 받은 이미지를 넣음
//                self?.artistProfileImageView.image = image
//            }
        }
        if todayCount == 1 {
            
        }
        
    }
    
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }

    @IBAction private func profileImageTapped(_ sender: UIButton) {
        let vc = ArtistProfileViewController()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func entireReservationBtnTapped(_ sender: UIButton) {
        let vc = ManagementReservationsViewController()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func reservationManagedBtnTapped(_ sender: UIButton){
        let vc = SingleArtistReservationManageViewController()
        let selectedIdx = sender.tag
        print(selectedIdx)
        vc.reservationData = reservationData[selectedIdx]
        vc.reservationDateString = formatDateString(op: 2,vc.reservationData.reservationDate)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func firstTodayResBtnDidTap(_ sender: UIButton) {
        if(todayCount != 0) {
            let vc = SingleArtistReservationManageViewController()
            vc.reservationData = reservationData[self.showReservationData[0]]
            vc.reservationDateString = formatDateString(op: 2,vc.reservationData.reservationDate)
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ArtistPortfolioManageViewController()
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func secondTodayResBtnDidTap(_ sender: UIButton) {
        let vc = SingleArtistReservationManageViewController()
        vc.reservationData = reservationData[self.showReservationData[1]]
        vc.reservationDateString = formatDateString(op: 2,vc.reservationData.reservationDate)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 예정 예약 중 오늘과 내일 이후 구별
    private func distinguishDate(reservationData: [ReservationData]){
        print("reservationData.count : \(reservationData.count)")
        print("reservationData.resDate : \(reservationData[0].reservationDate)")
        for i in 0..<reservationData.count {
            let dateString: String = reservationData[i].reservationDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 날짜 형식 설정
            if let date = dateFormatter.date(from: dateString) {
                let calendar = Calendar.current
                let now = Date()

                let UTCTimeZone = TimeZone(identifier: "UTC")!
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = UTCTimeZone
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                let gbtTime = dateFormatter.string(from: now)

                print("date : \(date)")
                print("now : \(now)")
                let difference = calendar.dateComponents([.day], from: now, to: date)
                if let days = difference.day {
                    if days < 0 {
                        reservationStatusData.append(-1)
                    } else {
                        // 미래
                        if calendar.isDateInToday(date) {
                            // 오늘
                            reservationStatusData.append(0)
                            if(todayCount<2){
                                showReservationData[todayCount] = i
                                todayCount += 1
                            }
                        }else {
                            // 내일 이후
                            if calendar.isDateInTomorrow(date){
                                // 내일
                                tomorrowCount += 1
                            }
                            reservationStatusData.append(1)
                            if(fromTomorrowCount<2){
                                showReservationData[fromTomorrowCount+2] = i
                                fromTomorrowCount += 1
                            }
                        }
                    }
                } else {
                    print("날짜 구별 실패2")
                }
            } else {
                print("날짜 구별 실패1")
            }
            
        }
    }
    public func formatDateString(op: Int,_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 입력된 날짜의 형식에 맞게 설정
        
        if let date = dateFormatter.date(from: dateString) {
            // 원하는 형식으로 날짜 문자열을 변환
            let UTCTimeZone = TimeZone(identifier: "UTC")!
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = UTCTimeZone
            if op==1 {
                dateFormatter.dateFormat = "yyyy. MM. dd EEE"
            }else if op==2{
                dateFormatter.dateFormat = "yyyy. MM. dd EEEE HH:mm시"
            }else{
                dateFormatter.dateFormat = "HH:mm"
            }
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: date)
        } else {
            print("날짜 구별 실패")
            return nil
        }
    }

    
    //MARK: - 아티스트 예약 조회 API
    private func getArtistReservation(artistId: Int){
        let getArtistReservation = ReservationManager.shared
        getArtistReservation.getArtistReservation(artistId: artistId) { result in
            switch result {
            case .success(let response) :
                print("res-success")
                self.reservationData = response.data
                self.distinguishDate(reservationData: self.reservationData)
                self.artistReservationStatusTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - 아티스트 프로필 조회 API
    func getArtistProfile(userId: Int, artistId: Int) {
        ProfileManager.shared.getArtistProfile(userId: userId, artistId: artistId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.artistProfileData = response.data
                self?.uiSet()
                print("아티스트 프로필 조회 성공: \(self?.artistProfileData?.nickname)")
            case .failure(let error):
                if let responseData = error.response {
                    let responseString = String(data: responseData.data, encoding: .utf8)
                    print("아티스트 프로필 조회 실패: \(responseString ?? "no data")")
                }
            }
        }
    }
    
}

extension ArtistHomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reservationData = reservationData else {
            return 0
        }
        return reservationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = reservationData[indexPath.row].makeupName
        cell.modelNameLabel.text = reservationData[indexPath.row].modelNickName
        cell.reservationDateLabel.text = formatDateString(op:1, reservationData[indexPath.row].reservationDate)
        cell.reservationTimeLabel.text = formatDateString(op:3, reservationData[indexPath.row].reservationDate)
        cell.reservationPlaceLabel.text = reservationData[indexPath.row].shopLocation
        cell.reservationPriceLabel.text = String(reservationData[indexPath.row].price)
        // 버튼 태그로 index 전달
        cell.reservationManageBtn.tag = indexPath.row
        cell.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        return cell
    }
    
}
extension ArtistHomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reservationStatusData[indexPath.row] == 1 {
            return CGFloat(192)
        }else {
            return CGFloat(0)
        }
    }
}
