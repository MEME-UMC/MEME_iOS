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
    
    // 받아와야하는 데이터
    private var artistNickName: String = "메메"
    private var artistId: Int = 10
    private var reservationData: [ReservationData]?
    
    
    private var reservationStatusData: [Int] = [1,2,3,0,1,2,3]
    private var todayRes: Int = 0
    private var tomorrowRes: Int = 0
    private var pastRes: Int = 0
    private var selectedIndex: [Int] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getArtistReservation(completion: { result in
            self.artistReservationStatusTableView.reloadData()
            for index in 0 ..< self.reservationStatusData.count {
                if self.reservationStatusData[index] == 1{
                    self.selectedIndex.append(index)
                }
            }
            if self.todayRes >= 1 {
                self.firstArtistResLabel.text = self.reservationData![self.selectedIndex[0]].makeupName
                self.firstArtistResBtnLabel.text = "예약"
                self.firstArtistResTimeLabel.text = self.dateConverter(mode: 1, dateString: self.reservationData![self.selectedIndex[0]].reservationDate)
            }
            if self.todayRes == 2 {
                self.secondArtistResLabel.text = self.reservationData![self.selectedIndex[1]].makeupName
                self.secondArtistTimeLabel.text = self.dateConverter(mode: 1, dateString: self.reservationData![self.selectedIndex[1]].reservationDate)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        uiSet()
        tableViewConfigure()
    }
    private func uiSet(){
        self.tabBarController?.tabBar.isHidden = false
        if todayRes == 0 {
            firstArtistResLabel.text = "포트폴리오 관리하러 가기"
            firstArtistResBtnLabel.text = ">"
            firstArtistResTimeLabel.text = nil
            secondArtistHomeProfileStatusView.isHidden = true
            secondArtistResBtn.isHidden = true
        }else if todayRes == 1 {
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
    
    private func getArtistReservation(completion: @escaping (Bool) -> Void){
        let getArtistReservation = ReservationManager.shared
        getArtistReservation.getArtistReservation(artistId: artistId) { result in
            switch result {
            case .success(let response):	
                self.reservationData = response.data
                for index in 0 ..< response.data!.count {
                    let date = Date()
                    let tmrdate = date + 1
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    let dateString = dateFormatter.string(from: date)
                    let tmrDateString = dateFormatter.string(from: tmrdate)
                    
                    let targetDate = self.dateConverter(mode: 1, dateString: self.reservationData![index].reservationDate)
                    
                    let tmrDate = self.dateConverter(mode: 1, dateString: tmrDateString)
                    let curDate = self.dateConverter(mode: 1, dateString: dateString)
//                    if curDate == targetDate {
//                        self.reservationStatusData.append(1) // 오늘 예약
//                        self.todayRes += 1
//                    }else if tmrDate == targetDate{
//                        self.reservationStatusData.append(2) // 내일 예약
//                        self.tomorrowRes += 1
//                    }else if curDate > targetDate {
//                        self.reservationStatusData.append(0) // 지난 예약
//                        self.pastRes += 1
//                    }else {
//                        self.reservationStatusData.append(3) // 모레~ 예약
//                    }
                }
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
        
    }

    @IBAction private func profileImageTapped(_ sender: UIButton) {
        let vc = ModelViewArtistProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func entireReservationBtnTapped(_ sender: UIButton) {
        let vc = EntireArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func firstTodayResBtnDidTap(_ sender: UIButton) {
        if(todayRes != 0) {
            let vc = SingleArtistReservationManageViewController(receivedData: reservationData![self.selectedIndex[0]])
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ArtistPortfolioManageViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction private func secondTodayResBtnDidTap(_ sender: UIButton) {
        let vc = SingleArtistReservationManageViewController(receivedData: reservationData![self.selectedIndex[1]])
        navigationController?.pushViewController(vc, animated: true)
    }
    func dateConverter(mode : Int, dateString : String) -> String {
        if mode == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.timeZone = TimeZone.init(identifier: "Europe/London")
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let timeString = timeFormatter.string(from: date)
                return timeString
            } else {
                return "noooooo"
            }
        }else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.timeZone = TimeZone.init(identifier: "Europe/London")
                dateFormatter.dateFormat = "yyyy.MM.dd."
                let formattedDateString = dateFormatter.string(from: date)
                // 날짜에서 요일을 가져옵니다.
                let calendar = Calendar.current
                let weekday = calendar.component(.weekday, from: date)
                
                // 요일을 문자열로 변환합니다.
                let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
                let weekdayString = weekdays[weekday - 1]
                return formattedDateString+weekdayString
            } else {
                return ""
            }
        }
    }
    
    
}

extension ArtistHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let res = reservationData else {
            return 0
        }
        let maxIndex = res.count
        var count = 0
        for i in 0..<maxIndex {
            if reservationStatusData[i] > 1 {
                count += 1
                if count == 2 {
                    return i+1
                }
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell
        else { return UITableViewCell() }
        
        guard let reservationData = self.reservationData else { return cell }
        cell.makeUpNameLabel.text = reservationData[indexPath.row].makeupName
        cell.modelNameLabel.text = reservationData[indexPath.row].modelNickName
        cell.reservationPriceLabel.text = String(reservationData[indexPath.row].price)
        cell.reservationPlaceLabel.text = reservationData[indexPath.row].shopLocation
        cell.reservationDateLabel.text = dateConverter(
            mode: 2,
            dateString: reservationData[indexPath.row].reservationDate
        )
        cell.reservationTimeLabel.text = dateConverter(
            mode: 1,
            dateString: reservationData[indexPath.row].reservationDate
        )
        cell.configure(reservationData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reservationStatusData[indexPath.row] > 1 {
            return 192
        } else {
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.className, for: indexPath) as! ArtistReservationStatusTableViewCell
        
        let vc = SingleArtistReservationManageViewController(receivedData: reservationData![indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
