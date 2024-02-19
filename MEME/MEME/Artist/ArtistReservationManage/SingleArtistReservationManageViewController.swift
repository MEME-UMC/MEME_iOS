//
//  ArtistReservationSingleManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/19/24.
//

import UIKit

class SingleArtistReservationManageViewController: UIViewController {
    
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelGenderLabel: UILabel!
    @IBOutlet weak var modelSkinTypeLabel: UILabel!
    @IBOutlet weak var modelPersonalColorLabel: UILabel!
    @IBOutlet weak var makeupNameLabel: UILabel!
    @IBOutlet weak var makeupTimeLabel: UILabel!
    @IBOutlet weak var makeupPlaceLabel: UILabel!
    @IBOutlet weak var modelProfileImgView: UIImageView!
    @IBOutlet private var cancelBarView: UIView!
    @IBOutlet private var cancelBarLabel: UILabel!
    @IBOutlet private var cancelBarButton: UIButton!
    @IBOutlet private var resInfoFrameView: UIView!
    let singleReservationData: ReservationData
    init(receivedData: ReservationData) {
        self.singleReservationData = receivedData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        // Do any additional setup after loading the view.
    }
    
    private func getModelProfile() {
        let getModelProfile = MyPageManager.shared
        // 모델 프로필 조회 API
        
    }
    private func isToday(dateString: String) -> Bool {
        // 현재 시간
        // DateFormatter 초기화
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // 오늘 날짜를 가져옵니다.
        let today = Date()
        // 주어진 날짜 문자열을 Date 객체로 변환합니다.
        if let date = dateFormatter.date(from: dateString) {
            // 오늘의 년, 월, 일 정보를 가져옵니다.
            let calendar = Calendar.current
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            // 주어진 날짜의 년, 월, 일 정보를 가져옵니다.
            let targetComponents = calendar.dateComponents([.year, .month, .day], from: date)
//            print(todayComponents.day, targetComponents.day)
            // 오늘과 주어진 날짜가 동일한지 확인합니다.
            if todayComponents.year == targetComponents.year &&
               todayComponents.month == targetComponents.month &&
               todayComponents.day == targetComponents.day {
                // 동일하다면 오늘입니다.
                return true
            }
        }

        // 오늘이 아닙니다.
        return false
    }

    
    private func uiSet(){
        makeupNameLabel.text = singleReservationData.makeupName
        print(singleReservationData.reservationDate)

        // 주어진 날짜 문자열
        let dateString = singleReservationData.reservationDate

        // DateFormatter 초기화
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        // 주어진 날짜 문자열을 Date 객체로 변환
        if let date = dateFormatter.date(from: dateString) {
            // 한국 시간대로 변환하기 위해 DateFormatter의 timeZone 속성 설정
            let outputFormatter = DateFormatter()
            outputFormatter.timeZone = TimeZone.init(identifier: "Europe/London")
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "M월 d일 EEEE HH:mm'시'"

            // 한국 시간대로 변환된 문자열 출력
            let outputString = outputFormatter.string(from: date)
            print(outputString) // 출력: "2월 18일 일요일 15:03시"
            makeupTimeLabel.text = outputString
        } else {
            // 주어진 날짜 문자열이 올바른 형식이 아닐 경우 에러 처리
            print("날짜 형식 오류")
            makeupTimeLabel.text = "날짜 형식 오류"
        }

        makeupPlaceLabel.text = singleReservationData.shopLocation
        modelNameLabel.text = singleReservationData.modelNickName

        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        cancelBarView.layer.cornerRadius=10
        resInfoFrameView.layer.cornerRadius=10
        if isToday(dateString: "2024-02-18T15:00:00.000+00:00") {
            cancelBarView.backgroundColor = .gray500
            cancelBarLabel.text = "당일 예약은 취소가 불가능합니다"
            cancelBarButton.isHidden = true
        }else{
            cancelBarView.backgroundColor = .systemRed
            cancelBarLabel.text = "예약 취소하기"
            cancelBarButton.isHidden = false
        }
    }
    
    @IBAction private func backBtnDidTap(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func reservationCancelBtnDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "예약 취소하기", message: "\n예약을 취소하시겠습니까? 취소 시 모델에게 취소 알림이 전송됩니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default, handler : nil )
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler : nil )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
    }
    


}
